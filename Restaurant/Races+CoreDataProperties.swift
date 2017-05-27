//
//  Races+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Races {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Races> {
        return NSFetchRequest<Races>(entityName: "Races")
    }

    @NSManaged public var dateRace: NSDate?
    @NSManaged public var toHippodrome: Hippodrome?
    @NSManaged public var toResults: NSSet?

}

// MARK: Generated accessors for toResults
extension Races {

    @objc(addToResultsObject:)
    @NSManaged public func addToToResults(_ value: Results)

    @objc(removeToResultsObject:)
    @NSManaged public func removeFromToResults(_ value: Results)

    @objc(addToResults:)
    @NSManaged public func addToToResults(_ values: NSSet)

    @objc(removeToResults:)
    @NSManaged public func removeFromToResults(_ values: NSSet)

}
