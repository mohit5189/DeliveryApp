//
//  DBManager+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 09/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import Foundation
import CoreData

extension DBManager {
    static func stub() -> DBManagerProtocol {
        let dbManager = DBManager.sharedInstance

        let mockManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        let mockStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mockManagedObjectModel!)
        _ = try? mockStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let mockManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        mockManagedObjectContext.persistentStoreCoordinator = mockStoreCoordinator

        dbManager.managedObjectContext = mockManagedObjectContext

        return dbManager
    }
}
