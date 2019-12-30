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

    func fetch<Element>(_ model: Element.Type, predicateFormat: String? = nil, completion:@escaping (([Element]?) -> Void)) where Element: DBObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: Element.self))
        fetchRequest.returnsObjectsAsFaults = false

        if let predicateFormat = predicateFormat {
            fetchRequest.predicate = NSPredicate.init(format: predicateFormat)
        }
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in

            guard let result = asynchronousFetchResult.finalResult as? [Element] else { completion(nil)
                return
            }
            completion(result as [Element])
        }
        do {
            _ = try backgroundContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
            completion(nil)
        }
    }

    func fetchAll<Element>(_ model: Element.Type, completion:@escaping (([Element]?) -> Void)) where Element: DBObject {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: Element.self))
            fetchRequest.returnsObjectsAsFaults = false

            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in

                guard let result = asynchronousFetchResult.finalResult as? [Element] else { completion(nil)
                    return
                }
                completion(result as [Element])
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

    func delete<Element>(_ model: Element.Type, object: DBObject, completion: @escaping () -> Void) throws where Element: DBObject {

        if let objectToBeDelete = object as? Element {
            if let objectToBeDelete: Story = objectToBeDelete as? Story {
                objectToBeDelete.storyStatus = Int32(StoryStatus.Deleted)
            }
            self.save {
                completion()
            }
        }
    }

    func deleteAll<Element>(_ model: Element.Type, completion:@escaping ((Bool) -> Void)) throws where Element: DBObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Element.self))
        fetchRequest.returnsObjectsAsFaults = false

        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [Element] else {
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

    func create<Element>(_ model: Element.Type, completion: @escaping ((Element?) -> Void)) throws where Element: DBObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Element.self), into: backgroundContext) as? Element
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
