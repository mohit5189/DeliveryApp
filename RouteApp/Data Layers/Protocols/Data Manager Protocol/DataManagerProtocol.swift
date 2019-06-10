//
//  DataManagerProtocol.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
protocol DataManagerProtocol {
    typealias CompletionBlock = (_ response: [DeliveryModel]?, _ error: Error?) -> Void
    func fetchData(offset: Int, limit: Int, completionHandler: @escaping CompletionBlock)
}
