//
//  MainCoordinator.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//


import Foundation
import RxSwift

enum MainTransition: Transition {
    case popViewController(animated: Bool)
    case showMapViewController(isEvent: Bool)
    case showDetailsViewController(viewModel: DetailsViewModel)
}

class MainCoordinator: NSObject, AppCoordinator {
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var mainViewModel: MainViewModel
    
    let coordinator = PublishSubject<StartAppTransition>()
    
    let transition = PublishSubject<MainTransition>()
        
    fileprivate let bag = DisposeBag()
    
    init(eventData: EventData, activities: [Activity]?, placeData: PlaceData) {
        rootViewController = UINavigationController()
        rootViewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        rootViewController.navigationBar.shadowImage = UIImage()
        
        self.mainViewModel = MainViewModel(provider: MyAPIServices(),
                                           eventData: eventData,
                                           activities: activities,
                                           placeData: placeData)
        let frontVC: MainViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
        frontVC.viewModel = mainViewModel
        frontVC.title = ""
        rootViewController.pushViewController(frontVC, animated: true)
        super.init()
        frontVC.viewModel.transition
            .subscribe(onNext: { [weak self] transition in
                self?.performTransition(transition: transition)
            }).disposed(by: bag)
    }
    
    deinit {
        print("DEINIT: MainCoordinator")
    }
    
    func start() {
        
    }
    
    func performTransition(transition: MainTransition) {
        switch transition {
        case .popViewController(let animated):
            rootViewController.popViewController(animated: animated)
        case .showMapViewController(let isEvent):
            let mapVC: MapViewController =  UIStoryboard(storyboardName: .Main).instantiateViewController()
            let mapVM = MapViewModel(mainViewModel: mainViewModel, isEvent: isEvent)
            mapVC.viewModel = mapVM
            rootViewController.pushViewController(mapVC, animated: true)
        case .showDetailsViewController(let vm):
            let vc: DetailsViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
            vc.viewModel = vm
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    
}
