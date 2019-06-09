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
    let offsetJsonKey   = "offset"
    let limitJsonKey    = "limit"
    
    var completionHandler = {() -> () in }
    var errorHandler = {(error: Error) -> () in }
    var loaderHandler = {(showLoader: Bool) -> () in }
    var pullToRefreshCompletionHandler = {() -> () in}
    var loadMoreCompletionHandler = {() -> () in}
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    var dbManager: DBManagerAdapter = DBManager.sharedInstance
    
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
    
    // Model properties
    func getDeliveryText(index: Int) -> String {
        return index < deliveryList.count ? String(format: "%@ at %@", deliveryList[index].description, deliveryList[index].location.address) : ""
    }
    
    func getImageUrl(index: Int) -> URL? {
        return index < deliveryList.count ? URL(string: deliveryList[index].imageUrl) : nil
    }
    
    // MARK: Handle loader
    private func handleProgressLoader(showLoader: Bool) {
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
    
    private func getInternetErrorObject() -> NSError {
        return NSError(domain: Constants.serverErrorDomain, code: Constants.internetErrorCode, userInfo: nil)
    }
    
    // MARK: API Handling
    
    func getEndPoint() -> String {
        let url = URLBuilder(baseUrl: Constants.baseURL, endPoint: Constants.endPoint)
        url.addQueryParameter(paramKey: offsetJsonKey, value: "\(offset)")
        url.addQueryParameter(paramKey: limitJsonKey, value: "\(limit)")
        return url.getFinalUrl()
    }
    
    func getDeliveryList() {
        guard reachabilityManager.isReachableToInternet() || dbManager.isCacheAvailable() else {
            loadMoreCompletionHandler()
            errorHandler(getInternetErrorObject())
            return
        }
        fetchDeliveries(networkClient: HTTPClient(url: getEndPoint()))
    }
    
    func makeNextPageCall() {
        guard isNextPageAvailable else {
            return
        }
        offset = deliveryList.count
        getDeliveryList()
    }
    
    func fetchDeliveries(networkClient: NetworkClientAdapter) {
        guard reachabilityManager.isReachableToInternet() else {
            handleListFromCache()
            return
        }
        
        handleProgressLoader(showLoader: true)
        let deliveryAdapter = DeliveryListAdapter(networkClient: networkClient)
        deliveryAdapter.fetchDeliveries { [weak self] response, error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.handleProgressLoader(showLoader: false)
            if error == nil, let deliveries = response as? [DeliveryModel] {
                weakSelf.isNextPageAvailable = deliveries.count > 0 // set pagination true if got records
                
                weakSelf.deliveryList = weakSelf.isPerformingPullToRefresh ? deliveries : (weakSelf.deliveryList + deliveries)
                
                DispatchQueue.main.async {
                    weakSelf.dbManager.saveDeliveries(deliveries: deliveries) // save deliveries in DB
                }
                
                weakSelf.updatePullToRefreshFlag()
            } else {
                weakSelf.handleListFromCache(serverError: error)
            }
        }
    }
    
    // MARK: Cache handling
    func handleListFromCache(serverError: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dbManager.getDeliveries(offset: weakSelf.offset, limit: weakSelf.limit) { [weak self] deliveries, dbError in
                guard let weakSelf = self else { return }
                if dbError == nil, let deliveries = deliveries, deliveries.count > 0 {
                    weakSelf.deliveryList = weakSelf.isPerformingPullToRefresh ? deliveries : (weakSelf.deliveryList + deliveries)
                } else {
                    weakSelf.loadMoreCompletionHandler()
                    if serverError != nil {
                        weakSelf.errorHandler(serverError!)
                    }
                }
                
                weakSelf.updatePullToRefreshFlag()
            }
        }
    }
}
