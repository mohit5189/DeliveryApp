//
//  DestinationListViewControllerTests.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import RouteApp

class DestinationListViewControllerTests: QuickSpec {
    var destinationListVC: DestinationListViewController!
    var loaderCell: LoaderCell!
    
    override func spec() {
        describe("DestinationListViewController") {
            context("when view is loaded") {
                beforeEach {
                    self.destinationListVC = DestinationListViewController.stub()
                }
                                
                context("and when setupUI is called") {
                    beforeEach {
                        self.destinationListVC.setupUI()
                    }
                    
                    it("should add tableview in view") {
                        expect(self.destinationListVC.tableView).notTo(beNil())
                    }
                }

                context("and when making api call for destination list and server gives error and no cache found") {
                    beforeEach {
                        DBManager.sharedInstance.cleanCache()
                        let networkClient = HTTPClientMock()
                        networkClient.jsonData = nil
                        networkClient.nextError = NSError(domain: "testError", code: 1, userInfo: nil)
                        self.destinationListVC.destinationListViewModel.fetchDestinations(networkClient: networkClient)
                    }
                    
                    it("should display error alert") {
                        expect(self.destinationListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                    
                    it("should not reset next page boolean variable") {
                        expect(self.destinationListVC.destinationListViewModel.isNextPageAvailable).to(beTrue())
                    }
                }
                
                context("and when making api call for destination list and server return valid list") {
                    beforeEach {
                        DBManager.sharedInstance.cleanCache()
                        let networkClient = HTTPClientMock()
                        networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "destination")
                        networkClient.nextError = nil
                        self.destinationListVC.destinationListViewModel.fetchDestinations(networkClient: networkClient)
                    }
                    
                    it("should render data in tableview") {
                        expect(self.destinationListVC.tableView.numberOfRows(inSection: 0) == self.destinationListVC.destinationListViewModel.numberOfRows()).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                    
                    it("should display loader at bottom") {
                        expect(self.destinationListVC.tableView(self.destinationListVC.tableView, cellForRowAt: IndexPath(row: self.destinationListVC.destinationListViewModel.numberOfRows() - 1, section: 0)).isKind(of: LoaderCell.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                    
                    context("and when stopSpinner method is called for loader cell") {
                        beforeEach {
                            self.loaderCell = self.destinationListVC.tableView(self.destinationListVC.tableView, cellForRowAt: IndexPath(row: self.destinationListVC.destinationListViewModel.numberOfRows() - 1, section: 0)) as! LoaderCell
                            self.loaderCell.stopSpinner()
                        }
                        
                        it("should stop and hide spinner") {
                            expect(self.loaderCell.spinner.isAnimating).to(beFalse())
                            expect(self.loaderCell.spinner.isHidden).to(beTrue())
                        }
                        
                        context("and when cell layoutSubviews is called") {
                            beforeEach {
                                self.loaderCell = (self.destinationListVC.tableView(self.destinationListVC.tableView, cellForRowAt: IndexPath(row: self.destinationListVC.destinationListViewModel.numberOfRows() - 1, section: 0)) as! LoaderCell)
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
                            self.destinationListVC = DestinationListViewController.stub(reachabilityManager: reachabilityMock)
                            self.destinationListVC.destinationListViewModel.destinationList = []
                            self.destinationListVC.destinationListViewModel.offset = 0
                            let networkClient = HTTPClientMock()
                            networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "destination")
                            networkClient.nextError = nil
                            self.destinationListVC.destinationListViewModel.fetchDestinations(networkClient: networkClient)
                        }
                        
                        it("should load 20 records from cache and should show loader at bottom") {
                            expect(self.destinationListVC.tableView.numberOfRows(inSection: 0) == 21).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                    }
                    
                    context("and when table scroll to bottom and will displaycell method called for next page") {
                        beforeEach {
                            self.destinationListVC.destinationListViewModel.offset = 0
                            self.destinationListVC.tableView.delegate!.tableView!(self.destinationListVC.tableView, willDisplay: LocationCell(), forRowAt: IndexPath(row: self.destinationListVC.destinationListViewModel.numberOfRows() - 1, section: 0))
                        }
                        
                        it("should update offset value for next page api call") {
                            expect(self.destinationListVC.destinationListViewModel.offset == self.destinationListVC.destinationListViewModel.destinationList.count).to(beTrue())
                        }
                                                
                        context("and when next page api call return success") {
                            beforeEach {
                                let networkClient = HTTPClientMock()
                                networkClient.jsonData = JSONHelper.jsonFileToData(jsonName: "destination")
                                networkClient.nextError = nil
                                self.destinationListVC.destinationListViewModel.fetchDestinations(networkClient: networkClient)
                            }
                            
                            it("should append data in array and should return numberOfRows accordingly") {
                                expect(self.destinationListVC.destinationListViewModel.numberOfRows() == 41).to(beTrue())
                            }
                        }
                    }

                    context("and when tapped on any address") {
                        beforeEach {
                            self.destinationListVC.tableView!.delegate?.tableView!(self.destinationListVC.tableView, didSelectRowAt: IndexPath (row: 1, section: 0))
                        }
                        
                        it("should open map screen with selected location parameter") {
                            expect(self.destinationListVC.navigationController?.topViewController!.isKind(of: MapViewController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                            
                            expect((self.destinationListVC.navigationController!.topViewController! as! MapViewController).viewModel.selectedLocation!.description == self.destinationListVC.destinationListViewModel.getDestination(index: 1).description).to(beTrue())
                        }
                    }
                }
                
                context("and when perform pull to refresh") {
                    context("and when internet if off") {
                        beforeEach {
                            let reachabilityMock = ReachabilityManagerMock()
                            reachabilityMock.isReachable = false
                            self.destinationListVC = DestinationListViewController.stub(reachabilityManager: reachabilityMock)
                            self.destinationListVC.destinationListViewModel.handlePullToRefresh()
                        }
                        
                        it("should display error alert") {
                            expect(self.destinationListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                        
                        it("should set isPerformingPullToRefresh to false") {
                            expect(self.destinationListVC.destinationListViewModel.isPerformingPullToRefresh).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
