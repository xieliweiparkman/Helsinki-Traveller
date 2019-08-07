//
//  AppErrors.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

enum AppError: Error {
    //General errors
    case networkError
    case unknownError
    case tooManyTry
    case authenticationFailed
    case addEventFailed
    case removeEventFailed
    case noCalendarAccess
    case MoyaErrors(error: Error)
}

extension AppError {
    var description: String {
        print(self)
        switch self {
        case .networkError:
            return "No internet connection"
        case .tooManyTry:
            return "You have tried too many times, please try again later."
        case .authenticationFailed:
            return "Authentication failed"
        case .unknownError:
            return "An error occurred. Please try again later."
        case .noCalendarAccess:
            return "Calendar access is not granted."
        case .addEventFailed:
            return "This event could not be added to your calendar, please offer the calendar permission."
        case .removeEventFailed:
            return "We could not found this event in your calendar or we cannot access your calendar."
        case .MoyaErrors(let error):
            return error.localizedDescription
        }
    }
}
