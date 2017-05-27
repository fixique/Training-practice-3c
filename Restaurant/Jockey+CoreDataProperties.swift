//
//  Jockey+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Jockey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Jockey> {
        return NSFetchRequest<Jockey>(entityName: "Jockey")
    }

    @NSManaged public var birthDate: NSDate?
    @NSManaged public var fullName: String?
    @NSManaged public var rating: Double
    @NSManaged public var toResults: NSSet?

}

// MARK: Generated accessors for toResults
extension Jockey {

    @objc(addToResultsObject:)
    @NSManaged public func addToToResults(_ value: Results)

    @objc(removeToResultsObject:)
    @NSManaged public func removeFromToResults(_ value: Results)

    @objc(addToResults:)
    @NSManaged public func addToToResults(_ values: NSSet)

    @objc(removeToResults:)
    @NSManaged public func removeFromToResults(_ values: NSSet)

}
