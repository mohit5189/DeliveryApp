//
//  DestinationListControllerViewModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class DestinationListControllerViewModel: NSObject {
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

    var isNextPageAvailable = true
    var isPerformingPullToRefresh = false {
        didSet {
            if !isPerformingPullToRefresh {
                pullToRefreshCompletionHandler()
            }
        }
    }
    
    var destinationList: [DestinationModel] = [] {
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
    
    // MARK: Handle loader
    private func handleProgressLoader(showLoader: Bool) {
        guard offset == 0, !isPerformingPullToRefresh else {
            return
        }
        loaderHandler(showLoader)
    }

    // MARK: TableView methods
    func numberOfRows() -> Int {
        if isNextPageAvailable, destinationList.count > 0 {
            return destinationList.count + 1
        }
        return destinationList.count
    }

    func getDestination(index:Int) -> DestinationModel {
        return destinationList[index]
    }
    
    
    // MARk: pull to refresh actiom
    func handlePullToRefresh() {
        isPerformingPullToRefresh = true
        offset = 0
        isNextPageAvailable = true
        if reachabilityManager.isReachableToInternet() {
            getDestinationList()
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

    func getDestinationList() {
        guard reachabilityManager.isReachableToInternet() || DBManager.sharedInstance.cacheAvailable() else {
            loadMoreCompletionHandler()
            errorHandler(getInternetErrorObject())
            return
        }
        fetchDestinations(networkClient: HTTPClient(url: getEndPoint()))
    }
    
    func makeNextPageCall() {
        guard isNextPageAvailable else {
            return
        }
        offset = destinationList.count
        getDestinationList()
    }
    
    func fetchDestinations(networkClient: NetworkClientAdapter) {
        guard reachabilityManager.isReachableToInternet() else {
            handleListFromCache()
            return
        }
        
        handleProgressLoader(showLoader: true)
        let destinationAdapter = DestinationListAdapter(networkClient: networkClient)
        destinationAdapter.fetchDestinations { [weak self] response, error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.handleProgressLoader(showLoader: false)
            if error == nil, let locations = response as? [DestinationModel] {
                weakSelf.isNextPageAvailable = locations.count > 0 // set pagination true if got records
                
                weakSelf.destinationList = weakSelf.isPerformingPullToRefresh ? locations : (weakSelf.destinationList + locations)
                
                DispatchQueue.main.async {
                    DBManager.sharedInstance.saveDestinations(destinations: locations) // save locations in DB
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
            DBManager.sharedInstance.getDestinations(offset: weakSelf.offset, limit: weakSelf.limit) { [weak self] destinations, dbError in
                guard let weakSelf = self else { return }
                if dbError == nil, let destinationList = destinations, destinationList.count > 0 {
                    weakSelf.destinationList = weakSelf.isPerformingPullToRefresh ? destinationList : (weakSelf.destinationList + destinationList)
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
