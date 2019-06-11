//
//  HTTPClientTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class HTTPClientTests: QuickSpec {
    var httpClient: HTTPClient!
    
    override func spec() {
        describe("HTTPClient") {
            beforeEach {
                self.httpClient = HTTPClient(url: "https://mock-api-mobile.dev.lalamove.com/deliveries")
            }
            
            context("when making api call") {
                context("and when server return error") {
                    beforeEach {
                        let session = URLSessionMock()
                        session.error = NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil)
                        session.data = nil
                        self.httpClient.session = session
                    }
                    
                    it("should call completion block with error object") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.httpClient.sendRequest(completionHandler: { data, error in
                                expect(error).notTo(beNil())
                                expect(data).to(beNil())
                                done()
                            })
                        }
                    }
                }
                
                context("and server return data") {
                    beforeEach {
                        let session = URLSessionMock()
                        session.error = nil
                        session.data = Data(bytes: [0, 1, 0, 1])
                        self.httpClient.session = session
                    }
                    
                    it("should call completion block with data") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.httpClient.sendRequest(completionHandler: { data, error in
                                expect(data).notTo(beNil())
                                expect(error).to(beNil())
                                done()
                            })
                        }
                    }
                }

            }
        }
    }
}
