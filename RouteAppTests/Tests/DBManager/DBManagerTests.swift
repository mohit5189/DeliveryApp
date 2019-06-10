//
//  DBManagerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class DBManagerTests: QuickSpec {
    var dbManager: DBManagerAdapter!
    let deliveryListJson = "deliveryList"
    override func spec() {
        describe("DBManager") {
            beforeEach {
                self.dbManager = DBManager.stub()
            }
            
            context("When saving records") {
                beforeEach {
                    self.dbManager.cleanCache()
                    do {
                        let decoder = JSONDecoder()
                        let deliveries = try decoder.decode([DeliveryModel].self, from: JSONHelper.jsonFileToData(jsonName: self.deliveryListJson)!)
                        self.dbManager.saveDeliveries(deliveries: deliveries)
                    } catch {
                        fail()
                    }
                }
                
                it("should save data in local db") {
                    expect(self.dbManager.allRecords().count == 20).to(beTrue())
                }
                
                context("and when make caching call again") {
                    beforeEach {
                        do {
                            let decoder = JSONDecoder()
                            let deliveries = try decoder.decode([DeliveryModel].self, from: JSONHelper.jsonFileToData(jsonName: self.deliveryListJson)!)
                            self.dbManager.saveDeliveries(deliveries: deliveries)
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should not make duplicate entries") {
                        expect(self.dbManager.allRecords().count == 20).to(beTrue())
                    }
                }
                
                context("and when fetching item with offset and limit") {
                    it("should return proper list as required") {
                        waitUntil(action: { done in
                            self.dbManager.getDeliveries(offset: 0, limit: 5, onSuccess: { destinations, error in
                                expect(destinations?.count == 5).to(beTrue())
                                done()
                            })
                        })
                    }
                }
            }
        }
    }
}
