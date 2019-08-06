//
//  LoadingCoordinator.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift

enum LoadingTransition: Transition {
    case showMainScreen(eventData: EventData, activities: [Activity], placeData: PlaceData)
}

class LoadingCoordinator: AppCoordinator {
    fileprivate let bag = DisposeBag()
    
    var rootViewController: UIViewController
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: Input
    let transition = PublishSubject<LoadingTransition>()
    //MARK: Output
    let outputTransition = PublishSubject<StartAppTransition>()
    
    init() {
        let loadingViewModel = LoadingViewModel(provider: MyAPIServices())
        let loadingVC: LoadingViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
        loadingVC.loadingViewModel = loadingViewModel
        rootViewController = loadingVC
        loadingViewModel.transition.bind(to: transition).disposed(by: bag)
    }
    
    deinit {
        print("DEINIT LoadingCoordinator")
    }
    
    func start() {
        transition
            .subscribe(onNext: { [weak self] (transition) in
                self?.performTransition(transition: transition)
            }).disposed(by: bag)
    }
    
    func performTransition(transition: LoadingTransition) {
        switch transition {
        case .showMainScreen(let eventData, let activities, let placeData):
            self.outputTransition.onNext(.showMainScreen(coordinator: self,
                                                         eventData: eventData,
                                                         activities: activities,
                                                         placeData: placeData))
        }
    }
}
