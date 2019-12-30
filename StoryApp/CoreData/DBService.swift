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
extension NSManagedObjectID: ObjectID {

}

struct Sorted {
    var key: String
    var isAcending: Bool
}

protocol UpdateDBService {
    associatedtype Element: DBObject
    func update(block: @escaping () -> Void) throws
}

protocol DeleteDBService {
    associatedtype Element: DBObject
    func delete<Element: DBObject>(_ model: Element.Type, object: DBObject, completion: @escaping () -> Void) throws
    func deleteAll<Element: DBObject>(_ model: Element.Type, completion:@escaping ((Bool) -> Void)) throws
    func reset() throws

}

protocol FetchDBService {
    associatedtype Element: DBObject
    func fetch<Element: DBObject>(_ model: Element.Type, predicateFormat: String?, completion:@escaping (([Element]?) -> Void))
    func fetchAll<Element: DBObject>(_ model: Element.Type, completion:@escaping (([Element]?) -> Void))
}

protocol ObjectFromFaultService {
    associatedtype FaultID: ObjectID
    func getObjectFromFault<FaultID: ObjectID>(objectID: FaultID, completion: ((DBObject?) -> Void))
}

protocol CreateDBService {
    func create<Element: DBObject>(_ model: Element.Type, completion: @escaping ((Element?) -> Void)) throws
}
protocol DBService: CreateDBService, FetchDBService, UpdateDBService, DeleteDBService, ObjectFromFaultService {
    func save(completion:() -> Void)
}
