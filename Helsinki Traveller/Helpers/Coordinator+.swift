//
//  Coordinator+.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
//MARK: Coordinator Protocol

//MARK: Transition
protocol Transition {}

//MARK: Coordinator
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    public func addChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    public func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

//MARK: RootViewControllerProvider
protocol RootViewControllerProvider: class {
    associatedtype Root: UIViewController
    var rootViewController: Root { get }
    
    func start()
    
    associatedtype T: Transition
    func performTransition(transition: T)
}

//MARK: AppCoordinator
typealias AppCoordinator = Coordinator & RootViewControllerProvider

//MARK: CoordinatorViewModelProtocol
protocol CoordinatorViewModelProtocol {
    associatedtype T: Transition
    var transition: PublishSubject<T> { get }
}
