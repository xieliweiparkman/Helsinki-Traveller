//
//  StartAppCoordinator.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum StartAppTransition: Transition {
    case showMainScreen(coordinator: Coordinator, eventData: EventData, activities: [Activity], placeData: PlaceData)
    case showLoadingScreen(coordinator: Coordinator)
}

final class StartAppCoordinator: AppCoordinator {
    fileprivate let bag = DisposeBag()
    
    var rootViewController: UIViewController
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: Input
    let window: UIWindow
    
    //MARK: Output
    let transition = PublishSubject<StartAppTransition>()
    
    init(window: UIWindow) {
        self.window = window
        
        let loadingCoordinator = LoadingCoordinator()
        loadingCoordinator.start()
        rootViewController = loadingCoordinator.rootViewController
        loadingCoordinator.outputTransition.bind(to: transition).disposed(by: bag)
        addChildCoordinator(loadingCoordinator)
    }
    
    deinit {
        print("DEINIT AppCoordinator")
    }
    
    func start() {
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        transition
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (transition) in
                self?.performTransition(transition: transition)
            }).disposed(by: bag)
    }
    
    func performTransition(transition: StartAppTransition) {
        switch transition {
        case .showMainScreen(let coordinator, let eventData, let activities, let placeData):
            print("Show main view")
            let mainCoordinator = MainCoordinator(eventData: eventData,
                                                  activities: activities,
                                                  placeData: placeData)
            
            rootViewController = mainCoordinator.rootViewController
            
            if window.rootViewController == nil {
                window.rootViewController = rootViewController
                return
            }
            window.rootViewController = rootViewController
            
            mainCoordinator.coordinator
                .subscribe(onNext: { transition in
                    self.performTransition(transition: transition)
                }).disposed(by: bag)
            
            addChildCoordinator(mainCoordinator)
            removeChildCoordinator(coordinator)
        case .showLoadingScreen(let coordinator):
            let loadingCoordinator = LoadingCoordinator()
            loadingCoordinator.start()
            rootViewController = loadingCoordinator.rootViewController
            if window.rootViewController == nil {
                window.rootViewController = rootViewController
                return
            }
            window.rootViewController = rootViewController
            loadingCoordinator.outputTransition.bind(to: self.transition).disposed(by: bag)
            addChildCoordinator(loadingCoordinator)
            removeChildCoordinator(coordinator)
        }
    }
}
