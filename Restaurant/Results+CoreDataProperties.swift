//
//  Results+CoreDataProperties.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Foundation
import CoreData


extension Results {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Results> {
        return NSFetchRequest<Results>(entityName: "Results")
    }

    @NSManaged public var place: Int16
    @NSManaged public var resultTime: Double
    @NSManaged public var toHorse: Horse?
    @NSManaged public var toJockey: Jockey?
    @NSManaged public var toRaces: Races?

}
