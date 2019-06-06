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
    var dbManager: DBManager!
    
    override func spec() {
        describe("DBManager") {
            beforeEach {
                self.dbManager = DBManager.sharedInstance
            }
            
            context("When saving records") {
                beforeEach {
                    self.dbManager.cleanCache()
                    do {
                        let decoder = JSONDecoder()
                        let locations = try decoder.decode([DestinationModel].self, from: JSONHelper.jsonFileToData(jsonName: "destination")!)
                        self.dbManager.saveDestinations(destinations: locations)
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
                            let locations = try decoder.decode([DestinationModel].self, from: JSONHelper.jsonFileToData(jsonName: "destination")!)
                            self.dbManager.saveDestinations(destinations: locations)
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should not make duplicate entries") {
                        expect(self.dbManager.allRecords().count == 20).to(beTrue())
                    }
                }
            }
            
            context("when fetching item with offset and limit") {
                it("should return proper list as required") {
                    waitUntil(action: { done in
                        self.dbManager.getDestinations(offset: 0, limit: 5, onSuccess: { destinations, error in
                            expect(destinations?.count == 5).to(beTrue())
                        })
                        
                        done()
                    })
                }
            }
        }
    }
}
