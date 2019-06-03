//
//  MapViewController.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapView: MKMapView!
    var destinationImageView: UIImageView!
    var destinationLabel: UILabel!
    var viewModel: MapControllerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = StringConstants.mapScreenTitle
        viewModel.getCurrentLocation()
        viewModel.currentLocationCompletionHandler = { [weak self] in
            self?.drawRoute()
        }
        dropDestinationPin()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        destinationImageView = UIImageView(frame: .zero)
        destinationImageView.translatesAutoresizingMaskIntoConstraints = false
        destinationImageView.sd_setImage(with: URL(string: viewModel.selectedLocation?.imageUrl ?? ""), placeholderImage: nil)
        view.addSubview(destinationImageView)
        
        destinationLabel = UILabel(frame: .zero)
        destinationLabel.numberOfLines = 0
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        if let selectedLocation = viewModel.selectedLocation {
            destinationLabel.text = String(format: "%@ at %@", selectedLocation.description, selectedLocation.location.address)
        }
        view.addSubview(destinationLabel)
        
        addCOnstraints()
    }
    
    func addCOnstraints() {
        let views: [String: Any] = [
            "mapView": mapView,
            "destinationImageView": destinationImageView,
            "destinationLabel": destinationLabel]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let mapHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[mapView]|",
            metrics: nil,
            views: views)
        allConstraints += mapHorizontalConstraints
        
        let bottomViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[destinationImageView(80)]-10-[destinationLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += bottomViewHorizontalConstraints
        
        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mapView]-10-[destinationImageView(80)]-50-|",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint

        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mapView]-10-[destinationLabel]-50-|",
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstraint

        view.addConstraints(allConstraints)

    }
}
