//
//  APIManagerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class APIManagerTests: QuickSpec {
    var apiManager: APIManagerProtocol!
    let validJson = "deliveryList"
    let invalidJson = "deliveryList3"
    var networkClientMock: HTTPClientMock!

    override func spec() {
        describe("DeliveryListManager") {
            beforeEach {
                self.apiManager = APIManager()
            }

            context("when make api call and server return valid response") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = nil
                    self.networkClientMock.jsonData = JSONHelper.jsonFileToData(jsonName: self.validJson)
                }

                it("should call completion block with data") {
                    waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                        self.apiManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { json, _ in
                            expect(json).notTo(beNil())
                            done()
                        })
                    }
                }
            }

            context("when make api call and server return invalid response") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = nil
                    self.networkClientMock.jsonData = JSONHelper.jsonFileToData(jsonName: self.invalidJson)
                }

                it("should call completion block with error") {
                    waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                        self.apiManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { json, error in
                            expect(error).notTo(beNil())
                            expect(json).to(beNil())
                            done()
                        })
                    }
                }
            }

            context("when make api call and server return error") {
                beforeEach {
                    self.networkClientMock = HTTPClientMock()
                    self.networkClientMock.nextError = NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil)
                    self.networkClientMock.jsonData = nil
                }

                it("should call completion block with error") {
                    waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                        self.apiManager.fetchDeliveries(networkClient: self.networkClientMock, completion: { _, error in
                            expect(error).notTo(beNil())
                            done()
                        })
                    }
                }
            }
        }
    }
}
