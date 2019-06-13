//
//  DeliveryListControllerViewModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

class DeliveryListControllerViewModel: NSObject, DeliveryListViewModelProtocol {
    var completionHandler: CompletionClosure?
    var errorHandler: ErrorClosure?
    var loaderHandler: LoaderClosure?
    var pullToRefreshCompletionHandler: CompletionClosure?
    var loadMoreCompletionHandler: LoaderClosure?
    var isApiCallInProgress = false

    var offset  = 0
    let limit   = 20

    var reachabilityManager: ReachabilityProtocol = ReachabilityManager.sharedInstance
    var dbManager: DBManagerProtocol = DBManager.sharedInstance
    var dataManager: DataManagerProtocol = DataManager()
    var isNextPageAvailable = true
    var isPerformingPullToRefresh = false {
        didSet {
            if !isPerformingPullToRefresh {
                pullToRefreshCompletionHandler?()
            }
        }
    }

    var deliveryList: [DeliveryModel] = [] {
        didSet {
            refreshData()
        }
    }

    func refreshData() {
        completionHandler?()
    }

    func updatePullToRefreshFlag() {
        if isPerformingPullToRefresh { // check to avoid unrequired processing to hide refresh control
            isPerformingPullToRefresh = false
        }
    }

    // MARK: Handle loader
    func handleProgressLoader(showLoader: Bool) {
        guard offset == 0, !isPerformingPullToRefresh else {
            return
        }
        loaderHandler?(showLoader)
    }

    // MARK: TableView methods
    func numberOfRows() -> Int {
        return deliveryList.count
    }

    func getDelivery(index: Int) -> DeliveryModel {
        return deliveryList[index]
    }

    // MARk: pull to refresh actiom
    func handlePullToRefresh() {
        isPerformingPullToRefresh = true
        offset = 0
        isNextPageAvailable = true
        if reachabilityManager.isReachableToInternet() {
            fetchDeliveryList()
        } else {
            errorHandler?(LocalizeStrings.ErrorMessage.internetErrorMessage)
            updatePullToRefreshFlag()
        }
    }
}
