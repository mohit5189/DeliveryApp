//
//  ReachabilityAdapter.swift
//  RouteApp
//
//  Created by Mohit Kumar on 06/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

protocol ReachabilityAdapter {
    func isReachableToInternet() -> Bool
}
