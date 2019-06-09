//
//  MapVireController+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 30/05/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import UIKit

extension MapViewController {
    static func stub() -> MapViewController {
        let mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: "", location: LocationModel(lat: 28.6927189, lng: 76.8111519, address: "delhi")))
        let viewController = MapViewController(viewModel: mapViewModel)
        _ = viewController.view
        return viewController
    }
}
