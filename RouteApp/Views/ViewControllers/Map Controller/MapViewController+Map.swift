//
//  MapViewController+Map.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    func drawRoute() {
        guard let currentLocation = viewModel.currentLocation else {
            return
        }

        let destinationLocation = CLLocationCoordinate2D(latitude: viewModel.getLatitude(), longitude: viewModel.getLongitude())

        let sourcePlaceMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile

        directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, _) in
            guard let response = response, let weakSelf = self else {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: LocalizeStrings.ErrorMessage.errorTitle, message: LocalizeStrings.ErrorMessage.routeErrorMessage)
                }
                return
            }

            let route = response.routes[0]
            weakSelf.mapView.addOverlay(route.polyline, level: .aboveRoads)
            var rect = route.polyline.boundingMapRect
            if rect.size.width > MapConstants.routeVisibilityArea || rect.size.height > MapConstants.routeVisibilityArea {
                rect.size.width += MapConstants.routeFrameExtraMargin
                rect.size.height += MapConstants.routeFrameExtraMargin
                rect.origin.x -= MapConstants.routeOriginExtraMargin
                rect.origin.y -= MapConstants.routeOriginExtraMargin
                weakSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }

    func dropDestinationPin() {
        let destinationLocation = CLLocationCoordinate2D(latitude: viewModel.getLatitude(), longitude: viewModel.getLongitude())
        let destinationPin = CustomPin(title: viewModel.getAddress(), location: destinationLocation)
        mapView.addAnnotation(destinationPin)
        let viewRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: MapConstants.routeVisibilityArea, longitudinalMeters: MapConstants.routeVisibilityArea)
        mapView.setRegion(viewRegion, animated: true)

    }

    // MARK: MKMapView delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polineLineRenderer = MKPolylineRenderer(overlay: overlay)
        polineLineRenderer.strokeColor = MapConstants.routeColor
        polineLineRenderer.lineWidth = MapConstants.routeLineWidth
        return polineLineRenderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MapConstants.markerIdentifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MapConstants.markerIdentifier)
            view.canShowCallout = true
            view.detailCalloutAccessoryView = UIView()
        }
        return view
    }

}
