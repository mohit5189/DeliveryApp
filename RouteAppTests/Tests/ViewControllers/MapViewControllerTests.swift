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
                    expect(self.mapVC.destinationLabel.text == String(format: "%@ at %@", self.mapVC.viewModel.selectedDelivery.description!, self.mapVC.viewModel.selectedDelivery.location!.address!)).to(beTrue())
                }
                
                it("should add marker at destination address") {
                    waitUntil(action: { done in
                        for annotation in self.mapVC.mapView.annotations {
                            if annotation.title == self.mapVC.viewModel.selectedDelivery.location!.address {
                                done()
                            }
                        }
                    })
                }
            }
        }
    }
}
