//
//  LoadingViewModel.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoadingViewModelProtocol {
    //Input
    var provider: MyAPIServicesProtocol? { get }
    
    //Output
    var transition: PublishSubject<LoadingTransition> { get }
    func setup()
}

class LoadingViewModel: LoadingViewModelProtocol {
    //Input
    var provider: MyAPIServicesProtocol?
    fileprivate let bag = DisposeBag()
    //Output
    let transition = PublishSubject<LoadingTransition>()
    
    init(provider: MyAPIServices?) {
        self.provider = provider
    }
    
    func setup() {
        guard let provider = provider else { return }
        let params: [String: Any] = ["limit": 50,
                                     "start": 0]
    
        Observable.zip(provider.getEvents(params: params),
                       provider.getActivities(params: params),
                       provider.getPlaces(params: params))
            .do(onNext: { _, _, _ in
                
            }, onError: { error in
                
            })
            .delay(0.75, scheduler: MainScheduler.instance)
            .subscribe(onNext: { eventData, activities, placeData in
                self.transition.onNext(.showMainScreen(eventData: eventData, activities: activities, placeData: placeData))
            }).disposed(by: bag)
    }
}
