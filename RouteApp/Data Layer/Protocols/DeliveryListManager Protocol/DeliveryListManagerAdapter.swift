//
//  DeliveryListManagerAdapter.swift
//  RouteApp
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

protocol DeliveryListManagerAdapter {
    typealias CompletionBlock = (_ response: Any?, _ error: Error?) -> Void
    func fetchDeliveries(networkClient: NetworkClientAdapter, completion: @escaping CompletionBlock)
}
