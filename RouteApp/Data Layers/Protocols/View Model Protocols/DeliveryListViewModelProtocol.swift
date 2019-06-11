//
//  DeliveryListViewModelProtocol.swift
//  RouteApp
//
//  Created by Mohit Kumar on 11/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

typealias CompletionClosure = (() -> Void)
typealias ErrorClosure = ((_ errorMessage: String) -> Void)
typealias LoaderClosure = ((_ showLoader: Bool) -> Void)

protocol DeliveryListViewModelProtocol {
    var completionHandler: CompletionClosure? {get set}
    var errorHandler: ErrorClosure? {get set}
    var loaderHandler: LoaderClosure? {get set}
    var pullToRefreshCompletionHandler: CompletionClosure? {get set}
    var loadMoreCompletionHandler: CompletionClosure? {get set}

    func handlePullToRefresh()
    func numberOfRows() -> Int
    func getDelivery(index: Int) -> DeliveryModel
    func fetchDeliveryList()
    func makeNextPageCall()
    func getDeliveryText(index: Int) -> String
    func getImageUrl(index: Int) -> URL?
    func getDeliveriesCount() -> Int
}
