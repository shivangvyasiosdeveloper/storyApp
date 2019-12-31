//
//  SyncManager.swift
//  StoryApp
//
//  Created by shivang on 30/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import CoreData
import Reachability

protocol Syncable {
    func GetUnsyncData(completion: @escaping (Bool) -> Void)
}

final class SyncManager: Syncable {
    private var syncData: [DBObject]?
    static let sharedManager = SyncManager()
    private init() {
        ReachabilityManager.sharedManager.addObserver(observer: self)
    }
    func GetUnsyncData(completion: @escaping (Bool) -> Void) {
        CoreDataService.sharedService.fetch(Story.self, predicateFormat: "storyStatus != \(StoryStatus.Unchanged)") { (unsynchedStories) in
            print("######################################")
            print("post this data to server via api...")
            print(unsynchedStories)
            print("######################################")
            print("once you receive status from server, mark these unsync data synced in db")
            print("######################################")
            completion(true)
        }
    }
}
extension SyncManager: ReachabilityChanged {
@objc func ConnectivityChanged(notification: Notification) {
        if let reachebility = notification.object as? Reachability {
            switch reachebility.connection {
            case .unavailable:
                print("internet unavailable")
            case .cellular, .wifi:
                print("Internet available")
                self.GetUnsyncData { (_) in
                }
            default:
                break
            }
        }
    }
}
