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
    func Sync(completion: @escaping (Bool) -> ())
}

final class SyncManager: Syncable {
    private var syncData: [DBObject]?
    static let sharedManager = SyncManager()
    private init(){
    }
    
    private func getSyncData() -> [DBObject]?{
        // get all stories which are updated locally..

        return nil
    }
    
    func Sync(completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}
