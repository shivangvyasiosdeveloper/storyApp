//
//  StoryListViewModel.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import Bond

protocol StoryListViewModelDelegate: class {
    func OpenSelected(story: Story?)
}

class StoryListViewModel: StoryListViewModelable {

    var selectedStoryIndex: Int?
    weak var delegate: StoryListViewModelDelegate?
    private var stories: [Story]?
    func getNoOfSections() -> Int {
        return 1
    }
    func getNoOfStories() -> Int {
        return stories?.count ?? 0
    }
}

extension StoryListViewModel {
    func getStoryAt(index: Int, completion: ((Story?)) -> Void) {
        guard index < stories?.count ?? 0 else {
            completion(nil)
            return
        }
        if let object = stories?[index] {
            if object.isFault {
                CoreDataService.sharedService.getObjectFromFault(objectID: object.objectID) { (nonFaultObject) in
                    completion(nonFaultObject as? Story)
                }
            } else {
                completion(object)
            }
        }
    }

    func getAllStories(completion:@escaping ([Story]?) -> Void) {
        CoreDataService.sharedService.fetch(Story.self, predicateFormat: "storyStatus != \(StoryStatus.Deleted)") { (stories) in
            self.stories = stories
            completion(stories)
        }
    }

}

extension StoryListViewModel {
    func removeAllStories(completion: @escaping () -> Void) {
        do {
            try CoreDataService.sharedService.deleteAll(Story.self, completion: { (_) in

            })
        } catch {
            completion()
        }
    }

    func removeStory(at: Int, completion: @escaping () -> Void) {
        do {
            let storyToBeDeleted = stories?[at]
            stories?.remove(at: at)
            if let deleteStory = storyToBeDeleted {
                try CoreDataService.sharedService.delete(Story.self, object: deleteStory, completion: {
                        completion()
               })
            }
        } catch {
            completion()
        }
    }
}

extension StoryListViewModel {
    func syncStories() {
        print("syncing stories to server....")
        // find those stories from coredata for which status != Unchanged and send all of them to server....if more data then use fetch size, fetch limit, fetch offset...

    }
}
