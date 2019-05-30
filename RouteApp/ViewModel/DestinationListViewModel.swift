//
//  DestinationListViewModel.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/28/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class DestinationListViewModel: NSObject {
    var completionHandler = {() -> () in }
    var reachabilityManager = Reachability(hostname: Constants.baseURL)
    var errorHandler = {(error:Error) -> () in }
    
    var offset = 0
    var limit = 20

    var destinationList: [DestinationModel] = [] {
        didSet {
            refreshData()
        }
    }

    func refreshData(){
        completionHandler();
    }

    // MARK: TableView methods
    
    func numberOfDestinations() -> Int {
        return destinationList.count
    }

    func getDestination(index:Int) -> DestinationModel {
        return destinationList[index]
    }
    
    
    private func handleProgressLoader(shouldShowLoader: Bool) {
        DispatchQueue.main.async {
            guard let view = UIApplication.shared.keyWindow?.rootViewController?.view  else {
                return
            }

            if shouldShowLoader {
                MBProgressHUD.showAdded(to: view, animated: true)
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }
    
    
    // MARK: API Handling

    func getDestinationList() {
        fetchDestinations(networkClient: HTTPClient(url: getEndPoint()))
    }
    
    func makeNextPageCall() {
        offset = offset + limit
        getDestinationList()
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
                    weakSelf.destinationList += locations
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
            destinationList += destinationsFromCache
        } else {
            offset = (offset == 0 ? offset - limit : offset)
            errorHandler(error)
        }
    }
}
