//
//  APIManagerProtocol.swift
//  RouteApp
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

protocol APIManagerProtocol {
    typealias CompletionBlock = (_ response: Any?, _ error: Error?) -> Void
    func fetchDeliveries(networkClient: HTTPClientProtocol, completion: @escaping CompletionBlock)
}
