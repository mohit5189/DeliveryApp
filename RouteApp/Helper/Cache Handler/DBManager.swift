import UIKit
import CoreData

class DBManager: NSObject {

    static var sharedInstance = DBManager()
    
    var managedObjectContext:NSManagedObjectContext?
    
    override init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    
    func saveDestinations(destinations:[DestinationModel]) -> Void {
        
        let destinationEntity = NSEntityDescription.entity(forEntityName: "Destination", in: managedObjectContext!)!
        let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedObjectContext!)!

        for destination in destinations {
            if !isDestinationExist(destinationID: destination.id) {
                let destinationModel:Destination = NSManagedObject(entity: destinationEntity, insertInto: managedObjectContext!) as! Destination
                
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
    
    func isDestinationExist(destinationID: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Destination")
        let predicate = NSPredicate(format: "id = %d", destinationID)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedObjectContext!.fetch(fetchRequest) as! [NSManagedObject]
            if records.count > 0 {
                return true
            }
        } catch {
        }
        return false
    }
    
    func getDestinations(offset: Int, limit: Int) -> [DestinationModel] {
        var destinations:[DestinationModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Destination")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        
        do {
            let records = try managedObjectContext!.fetch(fetchRequest) as! [Destination]
            for destination in records {
                let id = destination.id
                let desc = destination.desc
                let imageUrl = destination.imageUrl
                let lat = destination.location?.lat
                let long = destination.location?.long
                let address = destination.location?.address
                destinations.append(DestinationModel(id: Int(id), description: desc ?? "", imageUrl: imageUrl ?? "", location: AddressModel(lat: lat ?? 0, lng: long ?? 0, address: address ?? "")))
            }
        } catch {
        }
        
        return destinations
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
