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
            context("when view is loaded") {
                beforeEach {
                    self.deliveryListVC = DeliveryListViewController.stub()
                }
                
                context("and when setupUI is called") {
                    beforeEach {
                        self.deliveryListVC.setupUI()
                    }
                    
                    it("should add tableview in view") {
                        expect(self.deliveryListVC.tableView).notTo(beNil())
                    }
                }
                
                context("and when making api call for destination list and server gives error and no cache found") {
                    beforeEach {
                        DBManager.sharedInstance.cleanCache()
                        let networkClient = HTTPClientMock()
                        networkClient.jsonData = nil
                        networkClient.nextError = NSError(domain: "testError", code: 1, userInfo: nil)
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveries(networkClient: networkClient)
                    }
                    
                    it("should display error alert") {
                        expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                    
                    it("should not reset next page boolean variable") {
                        expect(self.deliveryListVC.deliveryListViewModel.isNextPageAvailable).to(beTrue())
                    }
                }
                
                context("and when making api call for destination list and server return valid list") {
                    beforeEach {
                        DBManager.sharedInstance.cleanCache()
                        let networkClient = HTTPClientMock()
                        networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "deliveryList")
                        networkClient.nextError = nil
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveries(networkClient: networkClient)
                    }
                    
                    it("should render data in tableview") {
                        expect(self.deliveryListVC.tableView.numberOfRows(inSection: 0) == self.deliveryListVC.deliveryListViewModel.numberOfRows()).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                    
                    it("should display loader at bottom") {
                        expect(self.deliveryListVC.tableView(self.deliveryListVC.tableView, cellForRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0)).isKind(of: LoaderCell.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
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
                    
                    
                    context("and when network not available") {
                        beforeEach {
                            let reachabilityMock = ReachabilityManagerMock()
                            reachabilityMock.isReachable = false
                            self.deliveryListVC = DeliveryListViewController.stub(reachabilityManager: reachabilityMock)
                            self.deliveryListVC.deliveryListViewModel.deliveryList = []
                            self.deliveryListVC.deliveryListViewModel.offset = 0
                            let networkClient = HTTPClientMock()
                            networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "deliveryList")
                            networkClient.nextError = nil
                            self.deliveryListVC.deliveryListViewModel.fetchDeliveries(networkClient: networkClient)
                        }
                        
                        it("should load 20 records from cache and should show loader at bottom") {
                            expect(self.deliveryListVC.tableView.numberOfRows(inSection: 0) == 21).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                    }
                    
                    context("and when table scroll to bottom and will displaycell method called for next page") {
                        beforeEach {
                            self.deliveryListVC.deliveryListViewModel.offset = 0
                            self.deliveryListVC.tableView.delegate!.tableView!(self.deliveryListVC.tableView, willDisplay: DeliveryCell(), forRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0))
                        }
                        
                        it("should update offset value for next page api call") {
                            expect(self.deliveryListVC.deliveryListViewModel.offset == self.deliveryListVC.deliveryListViewModel.deliveryList.count).to(beTrue())
                        }
                        
                        context("and when next page api call return success") {
                            beforeEach {
                                let networkClient = HTTPClientMock()
                                networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "deliveryList")
                                networkClient.nextError = nil
                                self.deliveryListVC.deliveryListViewModel.fetchDeliveries(networkClient: networkClient)
                            }
                            
                            it("should append data in array and should return numberOfRows accordingly") {
                                expect(self.deliveryListVC.deliveryListViewModel.numberOfRows() == 41).to(beTrue())
                            }
                        }
                    }
                    
                    context("and when tapped on any address") {
                        beforeEach {
                            self.deliveryListVC.tableView!.delegate?.tableView!(self.deliveryListVC.tableView, didSelectRowAt: IndexPath (row: 1, section: 0))
                        }
                        
                        it("should open map screen with selected location parameter") {
                            expect(self.deliveryListVC.navigationController?.topViewController!.isKind(of: MapViewController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                            
                            expect((self.deliveryListVC.navigationController!.topViewController! as! MapViewController).viewModel.getDescription() == self.deliveryListVC.deliveryListViewModel.getDelivery(index: 1).description).to(beTrue())
                        }
                    }
                }
                
                context("and when perform pull to refresh") {
                    context("and when internet if off") {
                        beforeEach {
                            let reachabilityMock = ReachabilityManagerMock()
                            reachabilityMock.isReachable = false
                            self.deliveryListVC = DeliveryListViewController.stub(reachabilityManager: reachabilityMock)
                            self.deliveryListVC.deliveryListViewModel.handlePullToRefresh()
                        }
                        
                        it("should display error alert") {
                            expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                        
                        it("should set isPerformingPullToRefresh to false") {
                            expect(self.deliveryListVC.deliveryListViewModel.isPerformingPullToRefresh).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
