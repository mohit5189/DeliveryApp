//
//  MapViewController+Map.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import MapKit

fileprivate let routeAreaExtraSize: Double = 5000

extension MapViewController: MKMapViewDelegate{
    func drawRoute() {
        guard let currentLocation = viewModel.currentLocation else {
            return
        }
        
        let destinationLocation = CLLocationCoordinate2D(latitude: viewModel.getLatitude() , longitude: viewModel.getLongitude())
        
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
            var rect = route.polyline.boundingMapRect
            rect.origin.y -= routeAreaExtraSize
            rect.size.width += routeAreaExtraSize
            rect.size.height += routeAreaExtraSize
            weakSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
        }
    }
    
    func dropDestinationPin() {
        let destinationLocation = CLLocationCoordinate2D(latitude: viewModel.getLatitude() , longitude: viewModel.getLongitude())
        let destinationPin = CustomPin(title: viewModel.getAddress(), location: destinationLocation)
        mapView.addAnnotation(destinationPin)
        let viewRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: routeVisibilityArea, longitudinalMeters: routeVisibilityArea)
        mapView.setRegion(viewRegion, animated: true)
        
    }
    
    // MARK: MKMapView delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polineLineRenderer = MKPolylineRenderer(overlay: overlay)
        polineLineRenderer.strokeColor = .red
        polineLineRenderer.lineWidth = routeLineWidth
        return polineLineRenderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: markerIdentifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: markerIdentifier)
            view.canShowCallout = true
            view.detailCalloutAccessoryView = UIView()
        }
        return view
    }
    
}
