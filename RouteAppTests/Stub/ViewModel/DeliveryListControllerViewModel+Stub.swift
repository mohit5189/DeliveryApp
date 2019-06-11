//
//  DeliveryListControllerViewModel+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

extension DeliveryListControllerViewModel {
    static func stub(reachabilityManager: ReachabilityManagerMock = ReachabilityManagerMock(isReachable: true)) -> DeliveryListControllerViewModel {
        let deliveryListViewModel = DeliveryListControllerViewModel()
        deliveryListViewModel.reachabilityManager = reachabilityManager
        return deliveryListViewModel
    }
}
