//
//  MapViewControllerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick
import MapKit
@testable import RouteApp

class MapViewControllerTests: QuickSpec {
    var mapVC: MapViewController!
    
    override func spec() {
        describe("MapViewController") {
            context("when view is loaded") {
                beforeEach {
                    self.mapVC = MapViewController.stub()
                }
                
                it("should have mapview added") {
                    expect(self.mapVC.mapView).notTo(beNil())
                }
                
                it("should display address at bottom") {
                    expect(self.mapVC.destinationLabel.text == String(format: "%@ at %@", self.mapVC.viewModel.selectedLocation!.description, self.mapVC.viewModel.selectedLocation!.location.address)).to(beTrue())
                }
                
                it("should add marker at destination address") {
                    expect(self.mapVC.mapView.annotations.count == 1).to(beTrue())
                }
                
                it("should set title for annotation") {
                    expect(self.mapVC.mapView.annotations[0].title == self.mapVC.viewModel.selectedLocation!.location.address).to(beTrue())
                }
            }
        }
    }
}
