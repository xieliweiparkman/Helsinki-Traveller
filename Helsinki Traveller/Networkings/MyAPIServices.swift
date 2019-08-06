//
//  MyAPIServices.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol MyAPIServicesProtocol {
    func getActivities(params: [String: Any]) -> Observable<[Activity]>
    func getEvents(params: [String: Any]) -> Observable<EventData>
    func getPlaces(params: [String: Any]) -> Observable<PlaceData>

}

class MyAPIServices: MyAPIServicesProtocol {
    private var provider: MoyaProvider<MyAPIS>
    
    init(provider: MoyaProvider<MyAPIS> = MoyaProvider<MyAPIS>(plugins: [NetworkLoggerPlugin(verbose: true,
                                                                                                       responseDataFormatter: JSONResponseDataFormatter)]), stubbed: Bool = false) {
        
        if (stubbed) {
            self.provider = MoyaProvider(stubClosure: MoyaProvider.immediatelyStub)
        } else {
            self.provider = provider
        }
    }
    
    static func newStubbingNetworking() -> MyAPIServices {
        return MyAPIServices.init(stubbed: true)
    }
    
    func void<T>(_: T) {
        return Void()
    }
    
    func getActivities(params: [String: Any]) -> Observable<[Activity]> {
        return provider.rx
            .request(.getActivities(params: params))
            .map([Activity].self, atKeyPath: "data", failsOnEmptyData: false)
            .asObservable()
    }
    
    func getEvents(params: [String: Any]) -> Observable<EventData> {
        return provider.rx
            .request(.getEvents(params: params))
            .map(EventData.self, atKeyPath: "/", failsOnEmptyData: false)
            .asObservable()
    }
    
    func getPlaces(params: [String: Any]) -> Observable<PlaceData> {
        return provider.rx
            .request(.getPlaces(params: params))
            .map(PlaceData.self, atKeyPath: "/", failsOnEmptyData: false)
            .asObservable()
    }
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        print("Error parsing json")
        return data // fallback to original data if it can't be serialized.
    }
}
