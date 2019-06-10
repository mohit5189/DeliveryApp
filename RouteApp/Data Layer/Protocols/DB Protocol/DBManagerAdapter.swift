//
//  DBManagerAdapter.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

typealias ResponseBlock = (_ response: [DeliveryModel]?, _ error: Error?) -> Void

protocol DBManagerAdapter {
    func saveDeliveries(deliveries: [DeliveryModel]) -> Void
    func getDeliveries(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock)
    func cleanCache()
    func allRecords() -> [Delivery]
    func isCacheAvailable() -> Bool
}