//
//  MapViewController+Map.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate{
    func drawRoute() {
        guard let destinationLatitude = viewModel.selectedLocation?.location.lat, let destinationLongitude = viewModel.selectedLocation?.location.lng, let currentLocation = viewModel.currentLocation else {
            return
        }
        
        let destinationLocation = CLLocationCoordinate2D(latitude:destinationLatitude , longitude: destinationLongitude)
        
        let sourcePlaceMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) in
            guard let response = response, let weakSelf = self else {
                return
            }
            
            let route = response.routes[0]
            weakSelf.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            weakSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func dropDestinationPin() {
        guard let destinationLatitude = viewModel.selectedLocation?.location.lat, let destinationLongitude = viewModel.selectedLocation?.location.lng else {
            return
        }
        
        let destinationLocation = CLLocationCoordinate2D(latitude:destinationLatitude , longitude: destinationLongitude)
        let destinationPin = CustomPin(title: viewModel.selectedLocation?.location.address ?? "", location: destinationLocation)
        mapView.addAnnotation(destinationPin)
        let viewRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(viewRegion, animated: true)

    }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polineLineRenderer = MKPolylineRenderer(overlay: overlay)
        polineLineRenderer.strokeColor = UIColor.red
        polineLineRenderer.lineWidth = 5.0
        return polineLineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.detailCalloutAccessoryView = UIView()
        }
        return view
    }

}
