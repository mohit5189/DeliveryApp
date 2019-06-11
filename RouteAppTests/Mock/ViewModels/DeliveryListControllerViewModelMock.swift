//
//  DeliveryListControllerViewModelMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

class DeliveryListControllerViewModelMock: NSObject, DeliveryListViewModelProtocol {
    var completionHandler: CompletionClosure?
    var errorHandler: ErrorClosure?
    var loaderHandler: LoaderClosure?
    var pullToRefreshCompletionHandler: CompletionClosure?
    var loadMoreCompletionHandler: CompletionClosure?

    var deliveries: [DeliveryModel] = []
    var errorExist: Bool = false
    var showLoader: Bool = false
    var isNextPageAvailable = true

    func handlePullToRefresh() {
        pullToRefreshCompletionHandler?()
    }

    func numberOfRows() -> Int {
        if isNextPageAvailable {
            return deliveries.count + 1
        }
        return deliveries.count
    }

    func getDelivery(index: Int) -> DeliveryModel {
        return deliveries[index]
    }

    func fetchDeliveryList() {
        guard errorExist else {
            deliveries = JSONHelper.getDeliveries()
            completionHandler?()
            loaderHandler?(showLoader)
            return
        }
        errorHandler?("test error")
        loadMoreCompletionHandler?()
    }

    func makeNextPageCall() {
        guard errorExist else {
            deliveries += JSONHelper.getDeliveries()
            completionHandler?()
            return
        }
        errorHandler?("test error")
        loadMoreCompletionHandler?()
    }

    func getDeliveryText(index: Int) -> String {
        guard deliveries.indices.contains(index), let desc = deliveries[index].description, let address = deliveries[index].location?.address else {
            return ""
        }
        return  String(format: "%@ at %@", desc, address)
    }

    func getImageUrl(index: Int) -> URL? {
        guard deliveries.indices.contains(index), let imageUrl = deliveries[index].imageUrl else {
            return nil
        }
        return URL(string: imageUrl)
    }

    func getDeliveriesCount() -> Int {
        return deliveries.count
    }

}
