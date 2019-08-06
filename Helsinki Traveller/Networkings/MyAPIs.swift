//
//  MyAPIs.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import Moya

typealias Params = [String: Any]

public enum MyAPIS {
    case getActivities(params: [String: Any])
    case getEvents(params: [String: Any])
    case getPlaces(params: [String: Any])
}

extension MyAPIS: TargetType {
    public var baseURL: URL {
        return URL(string: "http://open-api.myhelsinki.fi/")!
    }
    
    public var path: String {
        switch self {
        case .getActivities:
            return "v1/activities/"
        case .getEvents:
            return "v1/events/"
        case .getPlaces:
            return "v1/places/"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return stubbedResponse("DefaultSuccess")
    }
    
    public var task: Task {
        switch self {
        case .getActivities(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getEvents(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getPlaces(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
