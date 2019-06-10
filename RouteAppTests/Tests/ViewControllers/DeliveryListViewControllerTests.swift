//
//  DeliveryListViewControllerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class DeliveryListViewControllerTests: QuickSpec {
    var deliveryListVC: DeliveryListViewController!
    var loaderCell: LoaderCell!
    
    override func spec() {
        describe("DestinationListViewController") {
            beforeEach {
                self.deliveryListVC = DeliveryListViewController.stub()
            }
            context("when view is loaded") {
                context("and when setupUI is called") {
                    beforeEach {
                        self.deliveryListVC.setupUI()
                    }
                    
                    it("should add tableview in view") {
                        expect(self.deliveryListVC.tableView).notTo(beNil())
                    }
                }
            }
            
            context("when making api call to get deliveries list") {
                context("and when server return valid list of response") {
                    beforeEach {
                        let dataManagerMock = DataManagerMock(responseType: .deliveryList)
                        self.deliveryListVC.deliveryListViewModel.dataManagerAdapter = dataManagerMock
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveries()
                    }
                    
                    it("shold return valid list of deliveries") {
                        expect(self.deliveryListVC.deliveryListViewModel.deliveryList.isEmpty).to(beFalse())
                    }
                    
                    it("should load all deliveries in tableView") {
                        expect(self.deliveryListVC.tableView(self.deliveryListVC.tableView, numberOfRowsInSection: 0) == self.deliveryListVC.deliveryListViewModel.numberOfRows()).to(beTrue())
                    }
                    
                    it("should keep pagination enabled") {
                        expect(self.deliveryListVC.deliveryListViewModel.isNextPageAvailable).to(beTrue())
                    }
                    
                    context("and when stopSpinner method is called for loader cell") {
                        beforeEach {
                            self.loaderCell = (self.deliveryListVC.tableView(self.deliveryListVC.tableView, cellForRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0)) as! LoaderCell)
                            self.loaderCell.stopSpinner()
                        }
                        
                        it("should stop and hide spinner") {
                            expect(self.loaderCell.spinner.isAnimating).to(beFalse())
                            expect(self.loaderCell.spinner.isHidden).to(beTrue())
                        }
                        
                        context("and when cell layoutSubviews is called") {
                            beforeEach {
                                self.loaderCell = (self.deliveryListVC.tableView(self.deliveryListVC.tableView, cellForRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0)) as! LoaderCell)
                                self.loaderCell.setNeedsLayout()
                                self.loaderCell.layoutIfNeeded()
                                
                            }
                            
                            it("should display animated loader") {
                                expect(self.loaderCell.spinner.isAnimating).to(beTrue())
                                expect(self.loaderCell.spinner.isHidden).to(beFalse())
                            }
                        }
                    }
                    
                    context("and when server return error on next page call") {
                        beforeEach {
                            let dataManagerMock = DataManagerMock(responseType: .errorFromServer)
                            self.deliveryListVC.deliveryListViewModel.dataManagerAdapter = dataManagerMock
                            self.deliveryListVC.tableView(self.deliveryListVC.tableView, willDisplay: LoaderCell(), forRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0))
                        }
                        
                        it("should display error alert") {
                            expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                        
                        it("should have old record displayed") {
                            expect(self.deliveryListVC.deliveryListViewModel.deliveryList.isEmpty).to(beFalse())
                        }
                    }

                }
                
                context("and when internet and cache not available and app try to fetch deliveries") {
                    beforeEach {
                        let dbManagerMock = DBManager.stub()
                        dbManagerMock.cleanCache()
                        let reachabilityMock = ReachabilityManagerMock(isReachable: false)
                        self.deliveryListVC = DeliveryListViewController.stub(reachabilityManager: reachabilityMock)
                        self.deliveryListVC.deliveryListViewModel.dbManager = dbManagerMock
                        (self.deliveryListVC.deliveryListViewModel.dataManagerAdapter as! DataManager).dbManager = dbManagerMock
                        self.deliveryListVC.deliveryListViewModel.getDeliveryList()
                    }
                    
                    it("should display error alert") {
                        expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                }
                
                context("and when calling view model method for pull to refresh action") {
                    context("and when internet not available") {
                        beforeEach {
                            let reachabilityMock = ReachabilityManagerMock(isReachable: false)
                            self.deliveryListVC = DeliveryListViewController.stub(reachabilityManager: reachabilityMock)
                            self.deliveryListVC.deliveryListViewModel.handlePullToRefresh()
                        }
                        
                        it("should display error alert") {
                            expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                        
                        it("should make false to pullToRefresh boolean variable") {
                            expect(self.deliveryListVC.deliveryListViewModel.isPerformingPullToRefresh).to(beFalse())
                        }
                    }
                    
                    context("and when internet available") {
                        beforeEach {
                            let dataManagerMock = DataManagerMock(responseType: .deliveryList)
                            self.deliveryListVC.deliveryListViewModel.dataManagerAdapter = dataManagerMock
                            self.deliveryListVC.handlePullToRefresh(self.deliveryListVC.tableView)
                        }
                        
                        it("should load number of records and loader at bottom") {
                            expect(self.deliveryListVC.tableView.numberOfRows(inSection: 0) == 21).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                        
                        context("and when tap on any delivery in list") {
                            beforeEach {
                                self.deliveryListVC.tableView(self.deliveryListVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                            }
                            
                            it("should navigate to Map controller with view model object") {
                                expect(self.deliveryListVC.navigationController?.topViewController!.isKind(of: MapViewController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                                
                                expect((self.deliveryListVC.navigationController!.topViewController! as! MapViewController).viewModel.getDescription() == self.deliveryListVC.deliveryListViewModel.getDelivery(index: 0).description).to(beTrue())
                            }
                            
                        }
                    }
                }
                
                context("and when server return empty array in response") {
                    beforeEach {
                        let dataManagerMock = DataManagerMock(responseType: .emptyDeliveryList)
                        self.deliveryListVC.deliveryListViewModel.dataManagerAdapter = dataManagerMock
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveries()
                    }
                    
                    it("should disabled pagination") {
                        expect(self.deliveryListVC.deliveryListViewModel.isNextPageAvailable).to(beFalse())
                    }
                }
            }
            
            context("when trying to get delivery from viewModel and delivery index not found") {
                it("should return blank text if trying for text") {
                    expect(self.deliveryListVC.deliveryListViewModel.getDeliveryText(index: 100).isEmpty).to(beTrue())
                }
                
                it("should return nil if trying for image URL") {
                    expect(self.deliveryListVC.deliveryListViewModel.getImageUrl(index: 100)).to(beNil())
                }
            }
        }
    }
}
