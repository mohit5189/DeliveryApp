//
//  ReachabilityManagerMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 06/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

class ReachabilityManagerMock: ReachabilityProtocol {
    var isReachable: Bool!

    init(isReachable: Bool) {
        self.isReachable = isReachable
    }

    func isReachableToInternet() -> Bool {
        return isReachable
    }
}
