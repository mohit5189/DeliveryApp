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
    var selectedDelivery: DeliveryModel
    let locationHelper = LocationHelper.sharedInstance
    var  currentLocationCompletionHandler = {() -> () in }
    
    init(selectedDelivery: DeliveryModel) {
        self.selectedDelivery = selectedDelivery
        super.init()
    }
    
    var currentLocation: CLLocation? {
        didSet {
            currentLocationCompletionHandler()
        }
    }
    
    func getCurrentLocation() {
        locationHelper.initializeLocationManager()
        locationHelper.delegate = self
    }
    
    // Model properties
    func getDeliveryText() -> String {
        return String(format: "%@ at %@", selectedDelivery.description, selectedDelivery.location.address)
    }
    
    func getImageUrl() -> URL? {
        return URL(string: selectedDelivery.imageUrl)
    }
    
    func getLatitude() -> Double {
        return selectedDelivery.location.lat
    }
    
    func getLongitude() -> Double {
        return selectedDelivery.location.lng
    }
    
    func getAddress() -> String {
        return selectedDelivery.location.address
    }
    
    func getDescription() -> String {
        return selectedDelivery.description
    }

}

extension MapControllerViewModel: LocationHelperDelegate {
    func didUpdateCurrentLocation(location: CLLocation) {
        currentLocation  = location
    }
}
