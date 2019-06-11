//
//  DBManagerMock.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 10/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp
import CoreData
import UIKit

enum DBActionType {
    case deliveryList
    case error

    func handleResponse(onSuccess: @escaping ResponseBlock) {
        switch self {
        case .deliveryList:
            onSuccess(JSONHelper.getDeliveries(), nil)
        case .error:
            onSuccess(nil, NSError(domain: Constants.serverErrorDomain, code: Constants.serverErrorCode, userInfo: nil))
        }
    }

    func getDeliveriesList() -> [DeliveryModel] {
        switch self {
        case .deliveryList:
            return JSONHelper.getDeliveries()
        case .error:
             return [DeliveryModel]()
        }
    }
}
// swiftlint:disable force_cast
class DBManagerMock: NSObject, DBManagerProtocol {
    var managedObjectContext: NSManagedObjectContext?
    let deliveryEntity = "Delivery"
    let locationEntity = "Location"
    var dbActionType: DBActionType!

    init(dbActionType: DBActionType) {
        let mockManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        let mockStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mockManagedObjectModel!)
        _ = try? mockStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.managedObjectContext!.persistentStoreCoordinator = mockStoreCoordinator
        self.dbActionType = dbActionType
    }

    func saveDeliveries(deliveries: [DeliveryModel]) {

        let deliveryEntity = NSEntityDescription.entity(forEntityName: self.deliveryEntity, in: managedObjectContext!)!
        let locationEntity = NSEntityDescription.entity(forEntityName: self.locationEntity, in: managedObjectContext!)!

        for delivery in deliveries {
            var cacheDeliveryModel: Delivery? = getDeliveryFromCache(deliveryID: delivery.id)
            if cacheDeliveryModel == nil {
                cacheDeliveryModel = NSManagedObject(entity: deliveryEntity, insertInto: managedObjectContext!) as? Delivery
                cacheDeliveryModel?.location = NSManagedObject(entity: locationEntity, insertInto: managedObjectContext!) as? Location
            }
            if let deliveryModel = cacheDeliveryModel {
                deliveryModel.id = Int32(delivery.id)
                deliveryModel.desc = delivery.description
                deliveryModel.imageUrl = delivery.imageUrl
                deliveryModel.location?.setValue(delivery.location?.lat, forKey: "lat")
                deliveryModel.location?.setValue(delivery.location?.lng, forKey: "long")
                deliveryModel.location?.setValue(delivery.location?.address, forKey: "address")

                do {
                    try managedObjectContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func getDeliveryFromCache(deliveryID: Int) -> Delivery? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: deliveryEntity)
        let predicate = NSPredicate(format: "id = %d", deliveryID)
        fetchRequest.predicate = predicate

        do {
            let records = try managedObjectContext!.fetch(fetchRequest) as! [Delivery]
            if !records.isEmpty {
                return records[0]
            }
        } catch {
        }
        return nil
    }

    func getDeliveries(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock) {
        dbActionType.handleResponse(onSuccess: onSuccess)
    }

    func cleanCache() {
        do {
            let records = try managedObjectContext!.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: deliveryEntity)) as! [NSManagedObject]
            for record in records {
                managedObjectContext?.delete(record)
            }
        } catch {
        }
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    func allRecords() -> [Delivery] {
        return [Delivery]()
    }

    func isCacheAvailable() -> Bool {
        return !dbActionType.getDeliveriesList().isEmpty
    }
}
