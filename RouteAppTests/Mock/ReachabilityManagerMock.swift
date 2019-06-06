//
//  ReachabilityManagerMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 06/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

class ReachabilityManagerMock: ReachabilityAdapter {
    var isReachable = true
    
    func isReachableToInternet() -> Bool {
        return isReachable
    }
}
