//
//  Hippodrome+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Hippodrome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hippodrome> {
        return NSFetchRequest<Hippodrome>(entityName: "Hippodrome")
    }

    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var toRaces: NSSet?

}

// MARK: Generated accessors for toRaces
extension Hippodrome {

    @objc(addToRacesObject:)
    @NSManaged public func addToToRaces(_ value: Races)

    @objc(removeToRacesObject:)
    @NSManaged public func removeFromToRaces(_ value: Races)

    @objc(addToRaces:)
    @NSManaged public func addToToRaces(_ values: NSSet)

    @objc(removeToRaces:)
    @NSManaged public func removeFromToRaces(_ values: NSSet)

}
