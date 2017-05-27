//
//  Horse+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Horse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Horse> {
        return NSFetchRequest<Horse>(entityName: "Horse")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: String?
    @NSManaged public var nickName: String?
    @NSManaged public var toOwner: Owner?
    @NSManaged public var toResult: NSSet?

}

// MARK: Generated accessors for toResult
extension Horse {

    @objc(addToResultObject:)
    @NSManaged public func addToToResult(_ value: Results)

    @objc(removeToResultObject:)
    @NSManaged public func removeFromToResult(_ value: Results)

    @objc(addToResult:)
    @NSManaged public func addToToResult(_ values: NSSet)

    @objc(removeToResult:)
    @NSManaged public func removeFromToResult(_ values: NSSet)

}
