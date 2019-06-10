//
//  DataManager+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import Foundation
import CoreData

extension DataManager {
    static func stub(reachabilityManager: ReachabilityManagerMock = ReachabilityManagerMock(isReachable: true)) -> DataManagerAdapter {
        let dataManager = DataManager()
        dataManager.reachabilityManager = reachabilityManager
        return dataManager
    }
}
