//
//  ServerTime+CoreDataProperties.swift
//  
//
//  Created by Ankur on 30/12/19.
//
//

import Foundation
import CoreData

extension ServerTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerTime> {
        return NSFetchRequest<ServerTime>(entityName: "ServerTime")
    }

    @NSManaged public var lastRequestedTime: Date?

}
