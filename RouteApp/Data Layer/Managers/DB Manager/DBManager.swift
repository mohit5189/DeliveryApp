import UIKit
import CoreData

class DBManager: NSObject, DBManagerAdapter {
    
    static var sharedInstance = DBManager()
    var managedObjectContext:NSManagedObjectContext?
    let deliveryEntity = "Delivery"
    let locationEntity = "Location"
    
    override fileprivate init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    
    func saveDeliveries(deliveries: [DeliveryModel]) -> Void {
        
        let deliveryEntity = NSEntityDescription.entity(forEntityName: self.deliveryEntity, in: managedObjectContext!)!
        let locationEntity = NSEntityDescription.entity(forEntityName: self.locationEntity, in: managedObjectContext!)!
        
        for delivery in deliveries {
            var cacheDeliveryModel: Delivery? = getDeliveryFromCache(deliveryID: delivery.id)
            if cacheDeliveryModel == nil {
                cacheDeliveryModel = NSManagedObject(entity: deliveryEntity, insertInto: managedObjectContext!) as? Delivery
            }
            if let DeliveryModel = cacheDeliveryModel {
                DeliveryModel.id = Int32(delivery.id)
                DeliveryModel.desc = delivery.description
                DeliveryModel.imageUrl = delivery.imageUrl
                
                let location: Location = NSManagedObject(entity: locationEntity, insertInto: managedObjectContext!) as! Location
                location.lat = delivery.location.lat
                location.long = delivery.location.lng
                location.address = delivery.location.address
                
                DeliveryModel.location = location
                
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
            if records.count > 0 {
                return records[0]
            }
        } catch {
        }
        return nil
    }
    
    func getDeliveries(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock) {
        var deliveries:[DeliveryModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: deliveryEntity)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            DispatchQueue.main.async {
                if let result = asynchronousFetchResult.finalResult {
                    let records = result as! [Delivery]
                    
                    for delivery in records {
                        let id = delivery.id
                        let desc = delivery.desc
                        let imageUrl = delivery.imageUrl
                        let lat = delivery.location?.lat
                        let long = delivery.location?.long
                        let address = delivery.location?.address
                        deliveries.append(DeliveryModel(id: Int(id), description: desc ?? "", imageUrl: imageUrl ?? "", location: LocationModel(lat: lat ?? 0, lng: long ?? 0, address: address ?? "")))
                    }
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
            let records = try managedObjectContext!.fetch(Delivery.fetchRequest()) as! [NSManagedObject]
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
        do {
            let records = try managedObjectContext!.fetch(Delivery.fetchRequest()) as! [Delivery]
            return records
        } catch {
        }
        return []
    }
    
    func isCacheAvailable() -> Bool {
        return allRecords().count > 0
    }
}
