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
        viewModel.getCurrentLocation()
        viewModel.currentLocationCompletionHandler = { [weak self] in
            self?.drawRoute()
        }
        dropDestinationPin()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-80))
        mapView.delegate = self
        view.addSubview(mapView)
        
        destinationImageView = UIImageView(frame: CGRect(x: 10, y: mapView.frame.height + 10, width: 60, height: 60))
        destinationImageView.sd_setImage(with: URL(string: viewModel.selectedLocation?.imageUrl ?? ""), placeholderImage: nil)
        view.addSubview(destinationImageView)
        destinationLabel = UILabel(frame: CGRect(x: destinationImageView.frame.width + destinationImageView.frame.origin.x + 10, y: destinationImageView.frame.origin.y, width: view.frame.size.width - destinationImageView.frame.width - 30, height: destinationImageView.frame.height))
        destinationLabel.numberOfLines = 2
        if let selectedLocation = viewModel.selectedLocation {
            destinationLabel.text = String(format: "%@ at %@", selectedLocation.description, selectedLocation.location.address)
        }
        view.addSubview(destinationLabel)
    }
}
