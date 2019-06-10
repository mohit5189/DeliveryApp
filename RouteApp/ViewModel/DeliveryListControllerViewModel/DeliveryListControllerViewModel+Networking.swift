//
//  DeliveryListControllerViewModel+Networking.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

extension DeliveryListControllerViewModel {
    func getDeliveryList() {
        guard reachabilityManager.isReachableToInternet() || dbManager.isCacheAvailable() else {
            loadMoreCompletionHandler()
            errorHandler(getInternetErrorObject())
            return
        }
        fetchDeliveries()
    }
    
    func makeNextPageCall() {
        guard isNextPageAvailable else {
            return
        }
        offset = deliveryList.count
        getDeliveryList()
    }
    
    func fetchDeliveries() {
        handleProgressLoader(showLoader: true)
        dataManagerAdapter.fetchData(offset: offset, limit: limit) { [weak self] deliveries, error in
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
