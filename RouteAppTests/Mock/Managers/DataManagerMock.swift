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
    
    func handleRequest(completionHandler: @escaping DataManagerProtocol.CompletionBlock) {
        switch self {
        case .deliveryList:
            completionHandler(JSONHelper.getDeliveries(), nil)
        case .emptyDeliveryList:
            completionHandler([], nil)
        case .errorFromServer:
            completionHandler([], NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
        }
    }
}

class DataManagerMock: NSObject, DataManagerProtocol {
    var responseType: ResponseType!
    
    init(responseType: ResponseType) {
        super.init()
        self.responseType = responseType
    }
    
    func fetchData(offset: Int, limit: Int, completionHandler: @escaping CompletionBlock) {
        responseType.handleRequest(completionHandler: completionHandler)
    }
}
