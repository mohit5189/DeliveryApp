//
//  DataManagerAdapter.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
protocol DataManagerAdapter {
    typealias CompletionBlock = (_ response: [DeliveryModel]?, _ error: Error?) -> Void
    func fetchData(completionHandler: @escaping CompletionBlock)
}
