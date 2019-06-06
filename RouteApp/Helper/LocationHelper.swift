//
//  LocationHelper.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationHelperDelegate: class {
    func didUpdateCurrentLocation(location: CLLocation)
}

extension LocationHelperDelegate {
    func didUpdateCurrentLocation(location: CLLocation) {}
}

class LocationHelper: NSObject {
    
    static let sharedInstance = LocationHelper()
    
    override fileprivate init() {
        super.init()
        manager = CLLocationManager()
    }
    
    weak var delegate: LocationHelperDelegate?
    private var manager: CLLocationManager!
    var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation {
                delegate?.didUpdateCurrentLocation(location: location)
            }
        }
    }
    
    //Entry point to Location Manager. First the initialization has to be done
    func initializeLocationManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = false
        startUpdating()
    }
    
    //Start updating locations
    func startUpdating() {
        manager.startUpdatingLocation()
    }
}

//MARK: - CLLocation Manager delegate methods
extension LocationHelper: CLLocationManagerDelegate {
    //Updates locations when locations are received from hardware.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}
