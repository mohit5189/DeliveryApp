//
//  DeliveryListControllerViewModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class DeliveryListControllerViewModel: NSObject {
    var offset  = 0
    let limit   = 20
    
    var completionHandler = {() -> () in }
    var errorHandler = {(error: Error) -> () in }
    var loaderHandler = {(showLoader: Bool) -> () in }
    var pullToRefreshCompletionHandler = {() -> () in}
    var loadMoreCompletionHandler = {() -> () in}
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    var dbManager: DBManagerAdapter = DBManager.sharedInstance
    var dataManagerAdapter: DataManagerAdapter = DataManager()
    
    var isNextPageAvailable = true
    var isPerformingPullToRefresh = false {
        didSet {
            if !isPerformingPullToRefresh {
                pullToRefreshCompletionHandler()
            }
        }
    }
    
    var deliveryList: [DeliveryModel] = [] {
        didSet {
            refreshData()
        }
    }
    
    func refreshData() {
        completionHandler();
    }
    
    func updatePullToRefreshFlag() {
        if isPerformingPullToRefresh { // check to avoid unrequired processing to hide refresh control
            isPerformingPullToRefresh = false
        }
    }
    
    func getDeliveriesCount() -> Int {
        return deliveryList.count
    }
        
    // MARK: Handle loader
    func handleProgressLoader(showLoader: Bool) {
        guard offset == 0, !isPerformingPullToRefresh else {
            return
        }
        loaderHandler(showLoader)
    }
    
    // MARK: TableView methods
    func numberOfRows() -> Int {
        if isNextPageAvailable, deliveryList.count > 0 {
            return deliveryList.count + 1
        }
        return deliveryList.count
    }
    
    func getDelivery(index:Int) -> DeliveryModel {
        return deliveryList[index]
    }
    
    
    // MARk: pull to refresh actiom
    func handlePullToRefresh() {
        isPerformingPullToRefresh = true
        offset = 0
        isNextPageAvailable = true
        if reachabilityManager.isReachableToInternet() {
            getDeliveryList()
        } else {
            errorHandler(getInternetErrorObject())
            updatePullToRefreshFlag()
        }
    }
    
    func getInternetErrorObject() -> NSError {
        return NSError(domain: Constants.serverErrorDomain, code: Constants.internetErrorCode, userInfo: nil)
    }
}
