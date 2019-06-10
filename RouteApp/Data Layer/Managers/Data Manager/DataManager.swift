//
//  DataManager.swift
//  RouteApp
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

class DataManager: NSObject, DataManagerAdapter {
    var deliveryList: [DeliveryModel] = []
    var networkAdapter: NetworkClientAdapter!
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    var completionHandler: CompletionBlock!
    let offsetJsonKey   = "offset"
    let limitJsonKey    = "limit"
    var dbManager: DBManagerAdapter = DBManager.sharedInstance
    var deliveryAdapter: DeliveryListManagerAdapter = DeliveryListManager()
    
    func getEndPoint(offset: Int, limit: Int) -> String {
        let url = URLBuilder(baseUrl: Constants.baseURL, endPoint: Constants.endPoint)
        url.addQueryParameter(paramKey: offsetJsonKey, value: "\(offset)")
        url.addQueryParameter(paramKey: limitJsonKey, value: "\(limit)")
        return url.getFinalUrl()
    }
    
    func getNetworkClient(offset: Int, limit: Int) -> NetworkClientAdapter {
        return HTTPClient(url: getEndPoint(offset: offset, limit: limit))
    }

    func fetchData(offset: Int, limit: Int, completionHandler: @escaping CompletionBlock) {
        self.completionHandler = completionHandler
        
        guard reachabilityManager.isReachableToInternet() else {
            handleListFromCache(offset: offset, limit: limit)
            return
        }
        
        deliveryAdapter.fetchDeliveries(networkClient: getNetworkClient(offset: offset, limit: limit)) { [weak self] response, error in
            guard let weakSelf = self else {
                return
            }
            if error == nil, let deliveries = response as? [DeliveryModel] {
                DispatchQueue.main.async {
                    weakSelf.dbManager.saveDeliveries(deliveries: deliveries) // save deliveries in DB
                }
                completionHandler(deliveries, nil)
            } else {
                weakSelf.handleListFromCache(offset: offset, limit: limit, serverError: error)
            }
        }
    }
    
    // MARK: Cache handling
    func handleListFromCache(offset: Int, limit: Int, serverError: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dbManager.getDeliveries(offset: offset, limit: limit) { [weak self] deliveries, dbError in
                guard let weakSelf = self else { return }
                if dbError == nil, let deliveries = deliveries, deliveries.count > 0 {
                    weakSelf.completionHandler(deliveries, nil)
                } else {
                    weakSelf.completionHandler(nil, serverError)
                }
            }
        }
    }
}
