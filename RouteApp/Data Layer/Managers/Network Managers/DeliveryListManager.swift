//
//  DeliveryListManager.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

class DeliveryListManager: NSObject {
    typealias CompletionBlock = (_ response: Any?, _ error: Error?) -> Void
    
    func fetchDeliveries(networkClient: NetworkClientAdapter, completion: @escaping CompletionBlock) {
        networkClient.sendRequest { responseData, error in
            if error == nil,
                let data = responseData {
                do {
                    let decoder = JSONDecoder()
                    let locations = try decoder.decode([DeliveryModel].self, from: data)
                    completion(locations, nil)
                } catch {
                    completion(nil, NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
                }
            } else {
                completion(nil, NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
            }
        }
    }
}
