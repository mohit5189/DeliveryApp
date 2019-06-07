import UIKit
import CoreData

class DBManager: NSObject {
    
    static var sharedInstance = DBManager()
    
    var managedObjectContext:NSManagedObjectContext?
    
    typealias ResponseBlock = (_ response: [DestinationModel]?, _ error: Error?) -> Void
    
    override fileprivate init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    
    func saveDestinations(destinations:[DestinationModel]) -> Void {
        
        let destinationEntity = NSEntityDescription.entity(forEntityName: "Destination", in: managedObjectContext!)!
        let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedObjectContext!)!
        
        for destination in destinations {
            var cacheDestinationModel: Destination? = getDestinationFromCache(destinationID: destination.id)
            if cacheDestinationModel == nil {
                cacheDestinationModel = NSManagedObject(entity: destinationEntity, insertInto: managedObjectContext!) as? Destination
            }
            if let destinationModel = cacheDestinationModel {
                destinationModel.id = Int32(destination.id)
                destinationModel.desc = destination.description
                destinationModel.imageUrl = destination.imageUrl
                
                let location:Address = NSManagedObject(entity: addressEntity, insertInto: managedObjectContext!) as! Address
                location.lat = destination.location.lat
                location.long = destination.location.lng
                location.address = destination.location.address
                
                destinationModel.location = location
                
                do {
                    try managedObjectContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getDestinationFromCache(destinationID: Int) -> Destination? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Destination")
        let predicate = NSPredicate(format: "id = %d", destinationID)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedObjectContext!.fetch(fetchRequest) as! [Destination]
            if records.count > 0 {
                return records[0]
            }
        } catch {
        }
        return nil
    }
    
    func getDestinations(offset: Int, limit: Int, onSuccess: @escaping ResponseBlock) {
        var destinations:[DestinationModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Destination")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            DispatchQueue.main.async {
                if let result = asynchronousFetchResult.finalResult {
                    let records = result as! [Destination]
                    
                    for destination in records {
                        let id = destination.id
                        let desc = destination.desc
                        let imageUrl = destination.imageUrl
                        let lat = destination.location?.lat
                        let long = destination.location?.long
                        let address = destination.location?.address
                        destinations.append(DestinationModel(id: Int(id), description: desc ?? "", imageUrl: imageUrl ?? "", location: AddressModel(lat: lat ?? 0, lng: long ?? 0, address: address ?? "")))
                    }
                }
                onSuccess(destinations, nil)
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
            let records = try managedObjectContext!.fetch(Destination.fetchRequest()) as! [NSManagedObject]
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
    
    func allRecords() -> [Destination] {
        do {
            let records = try managedObjectContext!.fetch(Destination.fetchRequest()) as! [Destination]
            return records
        } catch {
        }
        return []
    }
    
    func cacheAvailable() -> Bool {
        return allRecords().count > 0
    }
}
