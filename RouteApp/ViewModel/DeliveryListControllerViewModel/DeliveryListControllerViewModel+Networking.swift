//
//  DeliveryListControllerViewModel+Networking.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

extension DeliveryListControllerViewModel {
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
        fetchDeliveries(networkClient: getNetworkClient())
    }
    
    func getNetworkClient() -> NetworkClientAdapter {
        return HTTPClient(url: getEndPoint())
    }
    
    func makeNextPageCall() {
        guard isNextPageAvailable else {
            return
        }
        offset = deliveryList.count
        getDeliveryList()
    }
    
    func fetchDeliveries(networkClient: NetworkClientAdapter) {
        handleProgressLoader(showLoader: true)
        dataManagerAdapter = DataManager(networkAdapter: networkClient, dbAdapter: dbManager, offset: offset, limit: limit)
        dataManagerAdapter?.fetchData { [weak self] deliveries, error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.handleProgressLoader(showLoader: false)
            if error == nil, let deliveries = deliveries {
                weakSelf.isNextPageAvailable = deliveries.count > 0 // set pagination true if got records
                weakSelf.deliveryList = weakSelf.isPerformingPullToRefresh ? deliveries : (weakSelf.deliveryList + deliveries)
            } else {
                weakSelf.loadMoreCompletionHandler()
                if error != nil {
                    weakSelf.errorHandler(error!)
                }
            }
            weakSelf.updatePullToRefreshFlag()
        }
    }
}
