//
//  DataManagerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

// swiftlint:disable force_cast
class DataManagerTests: QuickSpec {
    var dataManager: DataManagerProtocol!

    override func spec() {
        describe("DataManagerTests") {
            beforeEach {
                self.dataManager = DataManager.stub()
            }

            context("when making api call") {
                context("and when server return delivery list") {
                    beforeEach {
                        let apiManagerMock = APIManagerMock(deliveryListResponseType: .deliveriesList)
                        (self.dataManager as! DataManager).apiManager = apiManagerMock
                    }

                    it("should pass proper list in completion block") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.dataManager.fetchData(offset: 0, limit: 10, completionHandler: { deliveries, _ in
                                expect(deliveries?.isEmpty).to(beFalse())
                                done()
                            })
                        }
                    }
                }

                context("and when server return error and DB contains data") {
                    beforeEach {
                        let apiManagerMock = APIManagerMock(deliveryListResponseType: .errorFromServer)
                        (self.dataManager as! DataManager).apiManager = apiManagerMock
                        let dbManagerMock = DBManagerMock(dbActionType: .deliveryList)
                        (self.dataManager as! DataManager).dbManager = dbManagerMock
                    }

                    it("should return response from DB") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.dataManager.fetchData(offset: 0, limit: 10, completionHandler: { deliveries, _ in
                                expect(deliveries?.isEmpty).to(beFalse())
                                done()
                            })
                        }
                    }
                }

                context("and when server return error and DB contains no data") {
                    beforeEach {
                        let apiManagerMock = APIManagerMock(deliveryListResponseType: .errorFromServer)
                        (self.dataManager as! DataManager).apiManager = apiManagerMock
                        let dbManagerMock = DBManagerMock(dbActionType: .error)
                        (self.dataManager as! DataManager).dbManager = dbManagerMock
                    }

                    it("should return response from DB") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.dataManager.fetchData(offset: 0, limit: 10, completionHandler: { deliveries, _ in
                                expect(deliveries).to(beNil())
                                done()
                            })
                        }
                    }
                }

                context("and when internet is off and DB contains valid cache") {
                    beforeEach {
                        let reachabilityMock = ReachabilityManagerMock(isReachable: false)
                        self.dataManager = DataManager.stub(reachabilityManager: reachabilityMock)
                        let dbManagerMock = DBManagerMock(dbActionType: .deliveryList)
                        (self.dataManager as! DataManager).dbManager = dbManagerMock
                    }

                    it("should pass proper list in completion block") {
                        waitUntil(timeout: RouteAppTestConstants.timeoutInterval) { done in
                            self.dataManager.fetchData(offset: 0, limit: 10, completionHandler: { deliveries, _ in
                                expect(deliveries?.isEmpty).to(beFalse())
                                done()
                            })
                        }
                    }
                }

            }
        }
    }
}
