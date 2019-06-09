//
//  NetworkClientAdapter.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
protocol NetworkClientAdapter {
    typealias CompletionBlock = (_ response: Data?, _ error: Error?) -> Void
    func sendRequest(completionHandler: @escaping CompletionBlock)
}
