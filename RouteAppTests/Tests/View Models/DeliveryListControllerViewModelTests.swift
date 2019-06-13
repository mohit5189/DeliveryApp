//
//  DeliveryListControllerViewModelTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

import Foundation
import Nimble
import Quick

@testable import RouteApp

class DeliveryListControllerViewModelTests: QuickSpec {
    var deliveryListViewModel: DeliveryListControllerViewModel!

    override func spec() {
        describe("DeliveryListViewModelTests") {
            context("when making api call for deliveries list") {
                context("and when server return list of deliveries") {
                    beforeEach {
                        self.deliveryListViewModel = DeliveryListControllerViewModel.stub()
                        let dataManager = DataManagerMock(responseType: .deliveryList)
                        self.deliveryListViewModel.dataManager = dataManager
                        self.deliveryListViewModel.fetchDeliveryList()
                    }

                    it("should add list of deliveries in array") {
                        expect(self.deliveryListViewModel.deliveryList.count == 20).to(beTrue())
                    }

                    it("should make false to api call boolean variable") {
                        expect(self.deliveryListViewModel.isApiCallInProgress).to(beFalse())
                    }

                    context("and when making api call in case existing api going on") {
                        beforeEach {
                            self.deliveryListViewModel.isApiCallInProgress = true
                            self.deliveryListViewModel.fetchDeliveryList()
                        }

                        it("should not make further api call") {
                            expect(self.deliveryListViewModel.deliveryList.count == 20).to(beTrue())
                        }
                    }

                    context("and when returning delivery text and image URL") {
                        it("should return proper values") {
                            // using hardcoded values to match with JSON
                            expect(self.deliveryListViewModel.getDeliveryText(index: 0) == "Deliver documents to Andrio at Mong Kok").to(beTrue())

                            expect(self.deliveryListViewModel.getImageUrl(index: 0) == URL(string: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-0.jpeg")).to(beTrue())
                        }

                        context("and if index not exist in list") {
                            it("should return blank text for delivery") {
                                expect(self.deliveryListViewModel.getDeliveryText(index: 1000).isEmpty).to(beTrue())
                            }

                            it("should return nil image URL") {
                                expect(self.deliveryListViewModel.getImageUrl(index: 1000)).to(beNil())
                            }
                        }
                    }

                    context("and when returning number of rows") {
                        context("and when pagination is true") {
                            beforeEach {
                                self.deliveryListViewModel.isNextPageAvailable = true
                            }

                            it("should call bottom loader closure to show loader") {
                                self.deliveryListViewModel.makeNextPageCall()
                                self.deliveryListViewModel.loadMoreCompletionHandler = { showLoader in
                                    expect(showLoader).to(beTrue())
                                }
                            }
                        }

                        context("and when pagination is false") {
                            beforeEach {
                                self.deliveryListViewModel.isNextPageAvailable = false
                            }

                            it("should return deliveries in number of rows") {
                                expect(self.deliveryListViewModel.numberOfRows() == self.deliveryListViewModel.deliveryList.count).to(beTrue())
                            }
                        }

                    }

                    context("and when make next call and server return empty response") {
                        beforeEach {
                            let dataManager = DataManagerMock(responseType: .emptyDeliveryList)
                            self.deliveryListViewModel.dataManager = dataManager
                            self.deliveryListViewModel.makeNextPageCall()
                        }

                        it("should reset next page boolean variable") {
                            expect(self.deliveryListViewModel.isNextPageAvailable).to(beFalse())
                        }

                        it("should return array count in numberOfRows") {
                            expect(self.deliveryListViewModel.numberOfRows() == self.deliveryListViewModel.deliveryList.count).to(beTrue())
                        }
                    }
                }

                context("and when internet is off and trying to call for deliveries list") {
                    beforeEach {
                        let reachabilityMock = ReachabilityManagerMock(isReachable: false)
                        self.deliveryListViewModel = DeliveryListControllerViewModel.stub(reachabilityManager: reachabilityMock)
                        let dbManager = DBManagerMock(dbActionType: .error)
                        self.deliveryListViewModel.dbManager = dbManager
                        self.deliveryListViewModel.fetchDeliveryList()
                    }

                    it("should not return deliveries list") {
                        expect(self.deliveryListViewModel.numberOfRows() == 0).to(beTrue())
                    }
                }

                context("and when server return error response") {
                    beforeEach {
                        self.deliveryListViewModel = DeliveryListControllerViewModel.stub()
                        let dataManager = DataManagerMock(responseType: .errorFromServer)
                        self.deliveryListViewModel.dataManager = dataManager
                        self.deliveryListViewModel.fetchDeliveryList()
                    }

                    it("should return 0 as number of rows") {
                        expect(self.deliveryListViewModel.numberOfRows() == 0).to(beTrue())
                    }
                }

                context("and when call for pull to refresh") {
                    context("and when internet not available") {
                        beforeEach {
                            let reachabilityMock = ReachabilityManagerMock(isReachable: false)
                            self.deliveryListViewModel = DeliveryListControllerViewModel.stub(reachabilityManager: reachabilityMock)
                            self.deliveryListViewModel.handlePullToRefresh()
                        }

                        it("should make false to pullToRefresh boolean variable") {
                            expect(self.deliveryListViewModel.isPerformingPullToRefresh).to(beFalse())
                        }
                    }

                    context("and when internet available") {
                        beforeEach {
                            self.deliveryListViewModel = DeliveryListControllerViewModel.stub()
                            let dataManagerMock = DataManagerMock(responseType: .deliveryList)
                            self.deliveryListViewModel.dataManager = dataManagerMock
                            self.deliveryListViewModel.handlePullToRefresh()
                        }

                        it("should clean and add record in array") {
                            expect(self.deliveryListViewModel.deliveryList.count == 20).to(beTrue())
                        }

                        context("and whe getting any deliveryModel") {
                            it("should return valid model") {
                                expect(self.deliveryListViewModel.getDelivery(index: 0).description == "Deliver documents to Andrio").to(beTrue())
                            }
                        }
                    }
                }
            }
        }
    }
}
