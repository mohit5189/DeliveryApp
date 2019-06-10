//
//  ReachabilityManager.swift
//  RouteApp
//
//  Created by Mohit Kumar on 02/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: ReachabilityProtocol {
    var reachabilityManager: Reachability!

    static var sharedInstance = ReachabilityManager()
    fileprivate init() {
        reachabilityManager = Reachability(hostname: Constants.baseURL)
    }

    func isReachableToInternet() -> Bool {
        return reachabilityManager.connection != .none
    }
}
