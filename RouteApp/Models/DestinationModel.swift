//
//  DestinationModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

struct DestinationModel: Codable {
    let id: Int
    let description: String
    let imageUrl: String
    let location: AddressModel
}

struct AddressModel: Codable {
    let lat: Double
    let lng: Double
    let address: String
}
