import UIKit
import CoreData

// swiftlint:disable force_cast
class DBManager: NSObject, DBManagerProtocol {

    static var sharedInstance = DBManager()
    var managedObjectContext: NSManagedObjectContext?
    let deliveryEntity = "Delivery"
    let locationEntity = "Location"

    override fileprivate init() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
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
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }

    func getDeliveries(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock) {
        var deliveries: [DeliveryModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: deliveryEntity)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit

        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            DispatchQueue.main.async {
                if let result = asynchronousFetchResult.finalResult {
                    let records = result as! [Delivery]
                    deliveries = records.map({ delivery -> DeliveryModel in
                        let id = delivery.id
                        let desc = delivery.desc
                        let imageUrl = delivery.imageUrl
                        let lat = delivery.location?.lat
                        let long = delivery.location?.long
                        let address = delivery.location?.address
                        return DeliveryModel(id: Int(id), description: desc ?? "", imageUrl: imageUrl ?? "", location: LocationModel(lat: lat ?? 0, lng: long ?? 0, address: address ?? ""))
                    })
                }
                onSuccess(deliveries, nil)
            }

        }
        do {
            try managedObjectContext?.execute(asynchronousFetchRequest)
        } catch {
            onSuccess(nil, NSError(domain: "Invalid Query", code: 0, userInfo: nil))
        }
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
        var records: [Delivery] = []
        do {
            records = try managedObjectContext!.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: deliveryEntity)) as! [Delivery]
        } catch {
        }
        return records
    }

    func isCacheAvailable() -> Bool {
        return !allRecords().isEmpty
    }
}
