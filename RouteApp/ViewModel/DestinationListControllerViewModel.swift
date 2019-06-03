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
    var completionHandler = {() -> () in }
    var reachabilityManager = Reachability(hostname: Constants.baseURL)
    var errorHandler = {(error:Error) -> () in }
    var containsMoreRecords = true
    
    var offset = 0
    var limit = 20

    var performingPullToRefresh = false
    
    var destinationList: [DestinationModel] = [] {
        didSet {
            refreshData()
        }
    }

    func refreshData() {
        completionHandler();
    }

    // MARK: TableView methods
    
    func numberOfRows() -> Int {
        if containsMoreRecords, destinationList.count > 0 {
            return destinationList.count + 1
        }
        return destinationList.count
    }

    func getDestination(index:Int) -> DestinationModel {
        return destinationList[index]
    }
    
    private func handleProgressLoader(shouldShowLoader: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self, let view = UIApplication.shared.keyWindow?.rootViewController?.view, weakSelf.offset == 0, !weakSelf.performingPullToRefresh else {
                return
            }

            if shouldShowLoader {
                MBProgressHUD.showAdded(to: view, animated: true)
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }
    
    // MARk: pull to refresh actiom
    func handlePullToRefresh() {
        performingPullToRefresh = true
        offset = 0
        containsMoreRecords = true
        getDestinationList()
    }
    // MARK: API Handling

    func getDestinationList() {
        fetchDestinations(networkClient: HTTPClient(url: getEndPoint()))
    }
    
    func makeNextPageCall() {
        if containsMoreRecords {
            offset = destinationList.count
            getDestinationList()
        }
    }
    
    func getEndPoint() -> String {
        let url = URLBuilder(baseUrl: Constants.baseURL, endPoint: Constants.endPoint)
        url.addQueryParameter(paramKey: "offset", value: "\(offset)")
        url.addQueryParameter(paramKey: "limit", value: "\(limit)")
        return url.getFinalUrl()
    }

    func fetchDestinations(networkClient: NetworkClientAdapter) {
        if reachabilityManager?.isReachable ?? false {
            handleProgressLoader(shouldShowLoader: true)
            let destinationAdapter = DestinationListAdapter(networkClient: networkClient)
            destinationAdapter.fetchDestinations { [weak self] response, error in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.handleProgressLoader(shouldShowLoader: false)
                if error == nil, let locations = response as? [DestinationModel] {
                    weakSelf.containsMoreRecords = locations.count > 0 // set pagination true if got records

                    if weakSelf.performingPullToRefresh {
                        weakSelf.performingPullToRefresh = false
                        weakSelf.destinationList = locations
                    } else {
                        weakSelf.destinationList += locations
                    }
                    
                    DispatchQueue.main.async {
                        DBManager.sharedInstance.saveDestinations(destinations: locations) // save locations in DB
                    }
                } else {
                    weakSelf.handleListFromCache(error: error!)
                }
            }
        } else {
            handleListFromCache()
        }
    }
    
    func handleListFromCache(error: Error = NSError()) {
        let destinationsFromCache = DBManager.sharedInstance.getDestinations(offset: offset, limit: limit)
        if destinationsFromCache.count > 0 {
            if performingPullToRefresh {
                performingPullToRefresh = false
                destinationList = destinationsFromCache
            } else {
                destinationList += destinationsFromCache
            }
        } else {
            containsMoreRecords = false // set to false once received error from server
            errorHandler(error)
        }
    }
}
