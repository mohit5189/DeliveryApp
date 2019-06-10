//
//  DataManagerMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import Foundation

enum ResponseType {
    case deliveryList
    case emptyDeliveryList
    case errorFromServer
    
    func handleRequest(completionHandler: @escaping DataManagerAdapter.CompletionBlock) {
        switch self {
        case .deliveryList:
            completionHandler(getDeliveries(), nil)
        case .emptyDeliveryList:
            completionHandler([], nil)
        case .errorFromServer:
            completionHandler([], NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
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

class DataManagerMock: NSObject, DataManagerAdapter {
    var responseType: ResponseType!
    
    init(responseType: ResponseType) {
        super.init()
        self.responseType = responseType
    }
    
    func fetchData(offset: Int, limit: Int, completionHandler: @escaping CompletionBlock) {
        responseType.handleRequest(completionHandler: completionHandler)
    }
}
