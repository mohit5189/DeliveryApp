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
        let viewController = MapViewController()
        viewController.viewModel = MapControllerViewModel()
        viewController.viewModel.selectedLocation = DestinationModel(id: 0, description: "way to delhi", imageUrl: "", location: AddressModel(lat: 28.6927189, lng: 76.8111519, address: "delhi"))
        _ = viewController.view
        return viewController
    }
}
