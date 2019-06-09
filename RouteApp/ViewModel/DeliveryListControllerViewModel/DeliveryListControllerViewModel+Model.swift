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
        return index < deliveryList.count ? String(format: "%@ at %@", deliveryList[index].description, deliveryList[index].location.address) : ""
    }
    
    func getImageUrl(index: Int) -> URL? {
        return index < deliveryList.count ? URL(string: deliveryList[index].imageUrl) : nil
    }
}
