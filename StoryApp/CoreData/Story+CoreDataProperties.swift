//
//  Story+CoreDataProperties.swift
//  
//
//  Created by shivang on 29/12/19.
//
//

import Foundation
import CoreData

enum StoryStatus {
    static let Unchanged = 1
    static let Updated = 2
    static let Added = 3
    static let Deleted = 4
}

extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var storyDescription: String?
    @NSManaged public var storyTitle: String?
    @NSManaged public var storyId: UUID?
    @NSManaged public var storyStatus: Int32
    @NSManaged public var createdBy: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var modifiedBy: String?
    @NSManaged public var modifiedDate: Date?

}
