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
    var dbAdapter: DBManagerAdapter!
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    var completionHandler: CompletionBlock!
    var offset, limit: Int!
    
    init(networkAdapter: NetworkClientAdapter, dbAdapter: DBManagerAdapter, offset: Int, limit: Int) {
        super.init()
        self.dbAdapter = dbAdapter
        self.networkAdapter = networkAdapter
        self.offset = offset
        self.limit = limit
    }
    
    func fetchData(completionHandler: @escaping CompletionBlock) {
        self.completionHandler = completionHandler
        
        guard reachabilityManager.isReachableToInternet() else {
            handleListFromCache()
            return
        }
        
        let deliveryAdapter = DeliveryListManager(networkClient: networkAdapter)
        deliveryAdapter.fetchDeliveries { [weak self] response, error in
            guard let weakSelf = self else {
                return
            }
            if error == nil, let deliveries = response as? [DeliveryModel] {
                DispatchQueue.main.async {
                    weakSelf.dbAdapter.saveDeliveries(deliveries: deliveries) // save deliveries in DB
                }
                completionHandler(deliveries, nil)
            } else {
                weakSelf.handleListFromCache(serverError: error)
            }
        }
    }
    
    // MARK: Cache handling
    func handleListFromCache(serverError: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dbAdapter.getDeliveries(offset: weakSelf.offset, limit: weakSelf.limit) { [weak self] deliveries, dbError in
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
