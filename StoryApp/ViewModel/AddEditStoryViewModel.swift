//
//  AddStoryViewModel.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import Bond

enum StoryConstants {
     static let minTitleLength: Int = 2
     static let maxTitleLength: Int = 255
     static let minDescriptionLength: Int = 3
}

enum StoryValidationError: String, Error {
    case invalidStoryTitleLengthError = "Story Title should be min 2 length and maximum 255 length"
    case invalidStoryDescriptionLengthError = "Story Description should be min 2 length"
}

class AddEditStoryViewModel: AddStoryModelable, EditStoryModelable {
    var selectedStory: Story?
    var isValidStoryTitle: Observable<Bool> = Observable<Bool>(false)
    var isValidStoryDescription: Observable<Bool> = Observable<Bool>(false)
    var storyTitle: Observable<String?> = Observable<String?>("")
    var storyDescription: Observable<String?> = Observable<String?>("")
    var maxTitleLength: Int = StoryConstants.maxTitleLength
    var minTitleLength: Int = StoryConstants.minTitleLength
    var minDescriptionLength: Int = StoryConstants.minDescriptionLength

    init() {
        _ = storyTitle.map {
            if $0?.count ?? 0 <= self.maxTitleLength && $0?.count ?? 0 > self.minTitleLength {
                return true
            } else {
                return false
            }
        }.bind(to: isValidStoryTitle)

        _ = storyDescription.map {
            if $0?.count ?? 0 >= self.minDescriptionLength {
                return true
            } else {
                return false
            }
        }.bind(to: isValidStoryDescription)

    }

}

extension AddEditStoryViewModel {
    func addStory(completion:@escaping (Bool) -> Void) {
        do {
            try CoreDataService.sharedService.create(Story.self, completion: { (storyEntity) in
                if let storyEntity = storyEntity {
                    storyEntity.storyId = UUID()
                    print(UUID())
                    print(UUID().uuidString)
                    storyEntity.storyTitle = self.storyTitle.value
                    storyEntity.createdDate = Date()
                    storyEntity.createdBy = LoginUser.userId
                    storyEntity.storyStatus = Int32(StoryStatus.Added)
                    storyEntity.storyDescription = self.storyDescription.value
                    CoreDataService.sharedService.save {
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    func editStory(completion: @escaping (Bool) -> Void) {
        if let storyToBeEdit = selectedStory {
            storyToBeEdit.storyTitle = self.storyTitle.value
            storyToBeEdit.storyDescription = self.storyDescription.value
            storyToBeEdit.storyStatus = Int32(StoryStatus.Updated)
            storyToBeEdit.modifiedBy = LoginUser.userId
            storyToBeEdit.modifiedDate = Date()
            CoreDataService.sharedService.save {
                completion(true)
            }
        }
    }
}
