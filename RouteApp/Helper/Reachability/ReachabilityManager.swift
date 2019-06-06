//
//  ReachabilityManager.swift
//  RouteApp
//
//  Created by Mohit Kumar on 02/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

class ReachabilityManager: ReachabilityAdapter {
    var reachabilityManager: Reachability!

    static var sharedInstance = ReachabilityManager()
    init() {
        reachabilityManager = Reachability(hostname: Constants.baseURL)
    }

    func isReachableToInternet() -> Bool {
        return reachabilityManager.isReachable
    }
}
