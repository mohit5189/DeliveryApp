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
        guard let desc = selectedDelivery.description, let address = selectedDelivery.location?.address else {
            return ""
        }
        return String(format: "%@ at %@", desc, address)
    }
    
    func getImageUrl() -> URL? {
        return URL(string: selectedDelivery.imageUrl ?? "")
    }
    
    func getLatitude() -> Double {
        return selectedDelivery.location?.lat ?? 0
    }
    
    func getLongitude() -> Double {
        return selectedDelivery.location?.lng ?? 0
    }
    
    func getAddress() -> String {
        return selectedDelivery.location?.address ?? ""
    }
    
    func getDescription() -> String {
        return selectedDelivery.description ?? ""
    }

}

extension MapControllerViewModel: LocationHelperDelegate {
    func didUpdateCurrentLocation(location: CLLocation) {
        currentLocation  = location
    }
}
