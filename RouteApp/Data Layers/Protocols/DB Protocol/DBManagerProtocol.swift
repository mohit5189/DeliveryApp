//
//  DBManagerProtocol.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

typealias ResponseBlock = (_ response: [DeliveryModel]?, _ error: Error?) -> Void

protocol DBManagerProtocol {
    func saveDeliveries(deliveries: [DeliveryModel])
    func getDeliveries(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock)
    func cleanCache()
    func allRecords() -> [Delivery]
    func getDeliveryFromCache(deliveryID: Int) -> Delivery?
    func isCacheAvailable() -> Bool
}
