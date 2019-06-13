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

// swiftlint:disable force_cast
class DeliveryListViewControllerTests: QuickSpec {
    var deliveryListVC: DeliveryListViewController!

    override func spec() {
        describe("DestinationListViewController") {
            beforeEach {
                let viewModel = DeliveryListControllerViewModelMock()
                viewModel.deliveries = JSONHelper.getDeliveries()
                viewModel.errorExist = false
                self.deliveryListVC = DeliveryListViewController.stub(viewModel: viewModel)
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

                context("and when making api call first time to server and server return response") {
                    beforeEach {
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveryList()
                    }

                    it("should load data in tableview") {
                        expect(self.deliveryListVC.tableView.numberOfRows(inSection: 0) > 0).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }

                    context("and when select any row") {
                        beforeEach {
                            self.deliveryListVC.tableView(self.deliveryListVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                        }

                        it("should navigate to map screen with selected viewModel") {
                            expect(self.deliveryListVC.navigationController?.topViewController!.isKind(of: MapViewController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)

                            // used hardcoded string from JSON file
                            expect((self.deliveryListVC.navigationController?.topViewController as! MapViewController).viewModel.getDeliveryText() == "Deliver documents to Andrio at Mong Kok").to(beTrue())
                        }

                    }

                    context("and when willDisplay cell is called for next page") {
                        beforeEach {
                            self.deliveryListVC.tableView(self.deliveryListVC.tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: self.deliveryListVC.deliveryListViewModel.numberOfRows() - 1, section: 0))
                        }

                        it("should should append data in deliveryList") {
                            expect(self.deliveryListVC.deliveryListViewModel.numberOfRows() == 40).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                        }
                    }
                }

                context("and when called for bottom loader") {
                    beforeEach {
                        self.deliveryListVC.showBottomLoader()
                    }

                    it("should append activity indicator in table footer view") {
                        expect(self.deliveryListVC.tableView.tableFooterView!.isKind(of: UIActivityIndicatorView.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                }

                context("and when server return error") {
                    beforeEach {
                        let viewModel = DeliveryListControllerViewModelMock()
                        viewModel.errorExist = true
                        self.deliveryListVC = DeliveryListViewController.stub(viewModel: viewModel)
                        self.deliveryListVC.deliveryListViewModel.fetchDeliveryList()
                    }

                    it("should show error alert") {
                        expect(self.deliveryListVC.presentedViewController?.isKind(of: UIAlertController.self)).toEventually(beTrue(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                }

                context("and when called for pull to refresh and completion block is called") {
                    beforeEach {
                        self.deliveryListVC.handlePullToRefresh(self.deliveryListVC.tableView)
                    }

                    it("should stop refresh control") {
                        expect(self.deliveryListVC.refreshControl.isRefreshing).toEventually(beFalse(), timeout: RouteAppTestConstants.timeoutInterval)
                    }
                }
            }
        }
    }
}
