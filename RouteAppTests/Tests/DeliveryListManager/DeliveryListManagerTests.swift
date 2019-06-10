//
//  DeliveryListManagerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class DeliveryListManagerTests: QuickSpec {
    var deliveryListManager: DeliveryListManager!
    let validJson = "deliveryList"
    let invalidJson = "deliveryList3"
    var networkClientMock: HTTPClientMock!
    
    override func spec() {
        describe("DeliveryListManager") {
            beforeEach {
                self.deliveryListManager = DeliveryListManager()
            }
            
            context("when make api call and server return valid response") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = nil
                    self.networkClientMock.jsonData = JSONHelper.jsonFileToData(jsonName: self.validJson)
                }
                
                it("should call completion block with data") {
                    waitUntil(action: { done in
                        self.deliveryListManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { json, error in
                            expect(json).notTo(beNil())
                            done()
                        })
                    })
                }
            }
            
            context("when make api call and server return invalid response") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = nil
                    self.networkClientMock.jsonData = JSONHelper.jsonFileToData(jsonName: self.invalidJson)
                }
                
                it("should call completion block with error") {
                    waitUntil(action: { done in
                        self.deliveryListManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { json, error in
                            expect(error).notTo(beNil())
                            expect(json).to(beNil())
                            done()
                        })
                    })
                }
            }
            
            context("when make api call and server return error") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil)
                    self.networkClientMock.jsonData = nil
                }
                
                it("should call completion block with error") {
                    waitUntil(action: { done in
                        self.deliveryListManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { json, error in
                            expect(error).notTo(beNil())
                            done()
                        })
                    })
                }
            }


        }
    }
}
