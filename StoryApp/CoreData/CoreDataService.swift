//
//  CoreDataService.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataService: DBService {

    typealias FaultID = NSManagedObjectID
    typealias Element = NSManagedObject
    static let sharedService = CoreDataService()
    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        return backgroundContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StoryApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private init() {
    }

    func fetch<T>(_ model: T.Type, predicateFormat: String? = nil, completion:@escaping (([T]?) -> Void)) where T: DBObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: T.self))
        fetchRequest.returnsObjectsAsFaults = false

        if let predicateFormat = predicateFormat {
            fetchRequest.predicate = NSPredicate.init(format: predicateFormat)
        }
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in

            guard let result = asynchronousFetchResult.finalResult as? [T] else { completion(nil)
                return
            }
            completion(result as [T])
        }
        do {
            _ = try backgroundContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
            completion(nil)
        }
    }

    func fetchAll<T>(_ model: T.Type, completion:@escaping (([T]?) -> Void)) where T: DBObject {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: T.self))
            fetchRequest.returnsObjectsAsFaults = false

            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in

                guard let result = asynchronousFetchResult.finalResult as? [T] else { completion(nil)
                    return
                }
                completion(result as [T])
            }

            do {
                _ = try backgroundContext.execute(asynchronousFetchRequest)
            } catch let error {
                print("NSAsynchronousFetchRequest error: \(error)")
                completion(nil)
            }

    }

    func update(block: @escaping () -> Void) throws {

    }

    func delete<T>(_ model: T.Type, object: DBObject, completion: @escaping () -> Void) throws where T: DBObject {

        if let objectToBeDelete = object as? T {
            if let objectToBeDelete: Story = objectToBeDelete as? Story {
                objectToBeDelete.storyStatus = Int32(StoryStatus.Deleted)
            }
            self.save {
                completion()
            }
        }
    }

    func deleteAll<T>(_ model: T.Type, completion:@escaping ((Bool) -> Void)) throws where T: DBObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.returnsObjectsAsFaults = false

        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [T] else {
                completion(false)
                return
            }
                if let stories = result as? [Story] {
                    for story in stories {
                        story.storyStatus = Int32(StoryStatus.Deleted)
                    }
                }
                completion(true)
                return
            }

        do {
            _ = try backgroundContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
            completion(false)
        }
    }

    func reset() throws {

    }

    func create<T>(_ model: T.Type, completion: @escaping ((T?) -> Void)) throws where T: DBObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: backgroundContext) as? T
        completion(entity)
    }

    func save(completion: () -> Void) {
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        do {
            if backgroundContext.hasChanges {
                 try backgroundContext.save()
                    if persistentContainer.viewContext.hasChanges {
                        try persistentContainer.viewContext.save()
                    }
                 completion()
                return
            } else {
                 completion()
                return
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
             completion()
            return
        }
    }

    func getObjectFromFault<FaultID>(objectID: FaultID, completion: ((DBObject?) -> Void)) where FaultID: ObjectID {
        do {
            if let objectID = objectID as? NSManagedObjectID {
                let nonFaultObject: Element? = try self.backgroundContext.existingObject(with: objectID)
                completion(nonFaultObject)
           }
        } catch {
            completion(nil)
        }
    }

}

extension CoreDataService {
    func getSyncData<T>(_ model: T.Type, completion: @escaping (([T]?) -> Void)) throws where T: DBObject {
        fetch(model, predicateFormat: "storyStatus != \(StoryStatus.Unchanged)") { (_) in

        }
       }
}
