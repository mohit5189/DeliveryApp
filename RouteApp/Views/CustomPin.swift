//
//  CustomPin.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    static let currentLocationPinTitle = NSLocalizedString("currentLocationTitle", comment: "")
    
    init(title:String = currentLocationPinTitle, location:CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = location
    }
}
