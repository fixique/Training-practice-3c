//
//  Owner+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var address: String?
    @NSManaged public var fullName: String?
    @NSManaged public var passportNumber: String?
    @NSManaged public var toHorse: NSSet?

}

// MARK: Generated accessors for toHorse
extension Owner {

    @objc(addToHorseObject:)
    @NSManaged public func addToToHorse(_ value: Horse)

    @objc(removeToHorseObject:)
    @NSManaged public func removeFromToHorse(_ value: Horse)

    @objc(addToHorse:)
    @NSManaged public func addToToHorse(_ values: NSSet)

    @objc(removeToHorse:)
    @NSManaged public func removeFromToHorse(_ values: NSSet)

}
