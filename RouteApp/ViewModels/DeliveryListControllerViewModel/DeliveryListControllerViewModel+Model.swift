//
//  DeliveryListControllerViewModel+Model.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

extension DeliveryListControllerViewModel {
    func getDeliveryText(index: Int) -> String {
        guard deliveryList.indices.contains(index), let desc = deliveryList[index].description, let address = deliveryList[index].location?.address else {
            return ""
        }
        return  String(format: "%@ at %@", desc, address)
    }

    func getImageUrl(index: Int) -> URL? {
        guard deliveryList.indices.contains(index), let imageUrl = deliveryList[index].imageUrl else {
            return nil
        }
        return URL(string: imageUrl)
    }
}
