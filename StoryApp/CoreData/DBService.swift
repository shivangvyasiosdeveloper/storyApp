//
//  DBService.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import CoreData

protocol ObjectID {
    
}
extension NSManagedObjectID: ObjectID{
    
}

struct Sorted {
    var key: String
    var isAcending: Bool
}

protocol UpdateDBService {
    associatedtype T: DBObject
    func update(block: @escaping () -> Void) throws
}

protocol DeleteDBService {
    associatedtype T: DBObject
    func delete<T:DBObject>(_ model: T.Type, object: DBObject, completion: @escaping () -> ()) throws
    func deleteAll<T : DBObject>(_ model: T.Type, completion:@escaping ((Bool) -> Void)) throws
    func reset() throws

}

protocol FetchDBService {
    associatedtype T: DBObject
    func fetch<T: DBObject>(_ model: T.Type, predicateFormat: String?, completion:@escaping (([T]?) -> ()))
    func fetchAll<T:DBObject>(_ model: T.Type, completion:@escaping (([T]?) -> ()))
}

protocol ObjectFromFaultService {
    associatedtype F: ObjectID
    func getObjectFromFault<F: ObjectID>(objectID:F, completion: ((DBObject?) -> Void)) -> Void
}

protocol CreateDBService{
    func create<T: DBObject>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
}

protocol SyncService {
    func getSyncData<T:DBObject>(_ model: T.Type, completion: @escaping (([T]?) -> Void)) throws
}

protocol DBService: CreateDBService, FetchDBService, UpdateDBService, DeleteDBService, ObjectFromFaultService, SyncService {
    func save(completion:()->())
}
