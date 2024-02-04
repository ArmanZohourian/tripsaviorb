//
//  ContactEntity+CoreDataProperties.swift
//  
//
//  Created by Arman Zohourian on 1/30/24.
//
//

import Foundation
import CoreData


extension ContactEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntity> {
        return NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var familyName: String?
    @NSManaged public var phoneNumber: String?

}
