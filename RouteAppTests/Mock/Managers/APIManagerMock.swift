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

    func handleRequest(completion: @escaping APIManagerProtocol.CompletionBlock) {
        switch self {
        case .deliveriesList:
            completion(JSONHelper.getDeliveries(), nil)
        case .errorFromServer:
            completion([], NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
        }
    }
}

class APIManagerMock: NSObject, APIManagerProtocol {
    var deliveryListResponseType: DeliveryListResponseType!

    init(deliveryListResponseType: DeliveryListResponseType) {
        self.deliveryListResponseType = deliveryListResponseType
    }

    func fetchDeliveries(networkClient: HTTPClientProtocol, completion: @escaping CompletionBlock) {
        deliveryListResponseType.handleRequest(completion: completion)
    }
}
