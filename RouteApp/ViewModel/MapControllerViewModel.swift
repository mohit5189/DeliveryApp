//
//  MapControllerViewModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MapKit

class MapControllerViewModel: NSObject {
    var selectedLocation: DestinationModel?
    let locationHelper = LocationHelper.sharedInstance
    var  currentLocationCompletionHandler = {() -> () in }
    
    var currentLocation: CLLocation? {
        didSet {
            currentLocationCompletionHandler()
        }
    }
    
    func getCurrentLocation() {
        locationHelper.initializeLocationManager()
        locationHelper.delegate = self
    }
}

extension MapControllerViewModel: LocationHelperDelegate {
    func didUpdateCurrentLocation(location: CLLocation) {
        currentLocation  = location
    }
}
