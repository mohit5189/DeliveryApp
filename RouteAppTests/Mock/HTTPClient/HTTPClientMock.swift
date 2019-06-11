//
//  HTTPClientMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

class HTTPClientMock: HTTPClientProtocol {
    var jsonData: Data!
    var nextError: NSError?
    
    func sendRequest(completionHandler: @escaping HTTPClientProtocol.CompletionBlock) {
        completionHandler(jsonData, nextError)
    }
}
