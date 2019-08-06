//
//  DispatchUtil.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

// Executing task on background
public func runOnBackground(task: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: task)
}

/// Executing task on main thread
public func runOnMainThread(task: @escaping () -> Void) {
    if Thread.isMainThread {
        task()
    } else {
        DispatchQueue.main.async(execute: task)
    }
}

/// Executing task on queue
public func runOnQueue(qos: DispatchQoS.QoSClass,task: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: task)
}

/// Excuting task on main thread after x seconds
public func runOnMainThread(after: TimeInterval, task: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: task)
}
