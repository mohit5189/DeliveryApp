//
//  DeliveryListManagerMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

enum DeliveryListResponseType {
    case deliveriesList
    case errorFromServer
    
    func handleRequest(completion: @escaping DeliveryListManagerAdapter.CompletionBlock) {
        switch self {
        case .deliveriesList:
            completion(getDeliveries(), nil)
        case .errorFromServer:
            completion([], NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
        }
    }
    
    fileprivate func getDeliveries() -> [DeliveryModel] {
        let data = JSONHelper.jsonFileToData(jsonName: "deliveryList")
        do {
            let decoder = JSONDecoder()
            let deliveries = try decoder.decode([DeliveryModel].self, from: data!)
            return deliveries
        } catch {
            
        }
        return []
    }
}

class DeliveryListManagerMock: NSObject, DeliveryListManagerAdapter {
    var deliveryListResponseType: DeliveryListResponseType!
    
    init(deliveryListResponseType: DeliveryListResponseType) {
        self.deliveryListResponseType = deliveryListResponseType
    }
    
    func fetchDeliveries(networkClient: NetworkClientAdapter, completion: @escaping CompletionBlock) {
        deliveryListResponseType.handleRequest(completion: completion)
    }
}
