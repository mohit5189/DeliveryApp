//
//  DeliveryListControllerViewModel+Networking.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

extension DeliveryListControllerViewModel {
    func fetchDeliveryList() {
        guard reachabilityManager.isReachableToInternet() || dbManager.isCacheAvailable() else {
            loadMoreCompletionHandler?()
            errorHandler?(LocalizeStrings.ErrorMessage.internetErrorMessage)
            return
        }
        fetchDeliveries()
    }

    func makeNextPageCall() {
        guard isNextPageAvailable else {
            return
        }
        offset = deliveryList.count
        fetchDeliveryList()
    }

    func fetchDeliveries() {
        guard !isApiCallInProgress else {
            return
        }
        isApiCallInProgress = true
        handleProgressLoader(showLoader: true)
        dataManager.fetchData(offset: offset, limit: limit) { [weak self] deliveries, error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.isApiCallInProgress = false
            weakSelf.handleProgressLoader(showLoader: false)
            if error == nil, let deliveries = deliveries {
                weakSelf.isNextPageAvailable = !deliveries.isEmpty // set pagination true if got records
                weakSelf.deliveryList = weakSelf.isPerformingPullToRefresh ? deliveries : (weakSelf.deliveryList + deliveries)
            } else {
                weakSelf.loadMoreCompletionHandler?()
                if error != nil {
                    weakSelf.errorHandler?(LocalizeStrings.ErrorMessage.genericErrorMessage)
                }
            }
            weakSelf.updatePullToRefreshFlag()
        }
    }
}
