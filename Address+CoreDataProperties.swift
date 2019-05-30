//
//  Address+CoreDataProperties.swift
//  
//
//  Created by Mohit Kumar on 5/28/19.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var address: String?

}
