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
    var errorHandler = {(error:Error) -> () in }
    var containsMoreRecords = true
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    
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

    // MARK: Handle loader
    private func handleProgressLoader(showLoader: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self, let view = UIApplication.shared.keyWindow?.rootViewController?.view, weakSelf.offset == 0, !weakSelf.performingPullToRefresh else {
                return
            }
            
            if showLoader {
                MBProgressHUD.showAdded(to: view, animated: true)
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
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
    
    
    // MARk: pull to refresh actiom
    func handlePullToRefresh() {
        performingPullToRefresh = true
        offset = 0
        containsMoreRecords = true
        getDestinationList()
    }
    
    // MARK: API Handling

    func getEndPoint() -> String {
        let url = URLBuilder(baseUrl: Constants.baseURL, endPoint: Constants.endPoint)
        url.addQueryParameter(paramKey: "offset", value: "\(offset)")
        url.addQueryParameter(paramKey: "limit", value: "\(limit)")
        return url.getFinalUrl()
    }

    func getDestinationList() {
        fetchDestinations(networkClient: HTTPClient(url: getEndPoint()))
    }
    
    func makeNextPageCall() {
        if containsMoreRecords {
            offset = destinationList.count
            getDestinationList()
        }
    }
    
    func fetchDestinations(networkClient: NetworkClientAdapter) {
        if reachabilityManager.isReachableToInternet() {
            handleProgressLoader(showLoader: true)
            let destinationAdapter = DestinationListAdapter(networkClient: networkClient)
            destinationAdapter.fetchDestinations { [weak self] response, error in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.handleProgressLoader(showLoader: false)
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
                    weakSelf.handleListFromCache(error: error)
                }
            }
        } else {
            handleListFromCache()
        }
    }
    
    // MARK: Cache handling
    
    func handleListFromCache(error: Error? = nil) {
        DBManager.sharedInstance.getDestinations(offset: offset, limit: limit) { [weak self] destinations, dbError in
            guard let weakSelf = self else {
                return
            }
            
            if dbError == nil, let destinationList = destinations, destinationList.count > 0 {
                if weakSelf.performingPullToRefresh {
                    weakSelf.performingPullToRefresh = false
                    weakSelf.destinationList = destinationList
                } else {
                    weakSelf.destinationList += destinationList
                }
            } else {
                weakSelf.refreshData()
                weakSelf.containsMoreRecords = false // set to false once received error from server
                if error != nil {
                    weakSelf.errorHandler(error!)
                }
            }
        }
    }
}
