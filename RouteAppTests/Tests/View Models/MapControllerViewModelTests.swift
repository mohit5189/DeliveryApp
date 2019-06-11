//
//  MapControllerViewModelTests.swift
//  RouteApp
//
//  Created by Mohit Kumar on 11/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//


import Foundation

import Foundation
import Nimble
import Quick
import MapKit

@testable import RouteApp

class MapControllerViewModelTests: QuickSpec {
    var mapViewModel: MapControllerViewModel!
    
    override func spec() {
        describe("MapControllerViewModelTests") {
            beforeEach {
                self.mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: "www.google.com", location: LocationModel(lat: 28.6927189, lng: 76.8111519, address: "delhi")))
            }
            
            context("when called for delivery text") {
                context("and when values are proper") {
                    it("should return delivery text as per logic defined") {
                        expect(self.mapViewModel.getDeliveryText() == "way to delhi at delhi").to(beTrue())
                    }
                }
                
                context("and when either description OR address is missing") {
                    beforeEach {
                        self.mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: "", location: LocationModel(lat: 28.6927189, lng: 76.8111519, address: nil)))
                    }
                    
                    it("should return blank delivery text") {
                        expect(self.mapViewModel.getDeliveryText().isEmpty).to(beTrue())
                    }
                }
            }
            
            context("when called for image URL") {
                context("and when values are proper") {
                    it("should return valid image URL") {
                        expect(self.mapViewModel.getImageUrl()).notTo(beNil())
                    }
                }
                
                context("and when image URL is nil") {
                    beforeEach {
                        self.mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: nil, location: LocationModel(lat: 28.6927189, lng: 76.8111519, address: nil)))
                    }
                    
                    it("should return nil value") {
                        expect(self.mapViewModel.getImageUrl()).to(beNil())
                    }
                }
            }
            
            context("when called for latitude and longitude") {
                context("and when values are proper") {
                    it("should return values") {
                        expect(self.mapViewModel.getLatitude() == self.mapViewModel.selectedDelivery.location!.lat).to(beTrue())
                        expect(self.mapViewModel.getLongitude() == self.mapViewModel.selectedDelivery.location!.lng).to(beTrue())
                    }
                }
                
                context("and when values not found") {
                    beforeEach {
                        self.mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: nil, location: nil))
                    }
                    
                    it("should return 0 for latitude and longitude") {
                        expect(self.mapViewModel.getLatitude() == 0).to(beTrue())
                        expect(self.mapViewModel.getLongitude() == 0).to(beTrue())
                    }
                }
            }
            
            context("when called for address") {
                context("and when values are proper") {
                    it("should return address value") {
                        expect(self.mapViewModel.getAddress() == self.mapViewModel.selectedDelivery.location!.address).to(beTrue())
                    }
                }
                
                context("and when values not found") {
                    beforeEach {
                        self.mapViewModel = MapControllerViewModel(selectedDelivery: DeliveryModel(id: 0, description: "way to delhi", imageUrl: nil, location: nil))
                    }
                    
                    it("should return blank string") {
                        expect(self.mapViewModel.getAddress().isEmpty).to(beTrue())
                    }
                }
            }
            
            context("when location delegate method is called") {
                beforeEach {
                    self.mapViewModel.didUpdateCurrentLocation(location: CLLocation(latitude: 28.6927189, longitude: 28.6927189))
                }
                
                it("should set location variable") {
                    expect(self.mapViewModel.currentLocation).notTo(beNil())
                }
            }

        }
    }
}
