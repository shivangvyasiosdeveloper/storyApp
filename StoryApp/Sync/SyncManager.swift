//
//  SyncManager.swift
//  StoryApp
//
//  Created by shivang on 30/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import CoreData

protocol Syncable {
    func Sync(completion: @escaping (Bool) -> Void)
}

final class SyncManager: Syncable {
    private var syncData: [DBObject]?
    static let sharedManager = SyncManager()
    private init() {
    }
    func Sync(completion: @escaping (Bool) -> Void) {
        CoreDataService.sharedService.fetch(Story.self, predicateFormat: "storyStatus != \(StoryStatus.Unchanged)") { (unsynchedStories) in
//            print(unsynchedStories)
        }
        completion(true)
    }
}
