//
//  Destination+CoreDataProperties.swift
//  
//
//  Created by Mohit Kumar on 5/28/19.
//
//

import Foundation
import CoreData


extension Destination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Destination> {
        return NSFetchRequest<Destination>(entityName: "Destination")
    }

    @NSManaged public var id: Int32
    @NSManaged public var desc: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var location: Address?

}
