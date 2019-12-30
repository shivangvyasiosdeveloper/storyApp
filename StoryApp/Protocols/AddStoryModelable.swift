//
//  AddStoryModelable.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import Bond

protocol StoryModelable {
    var storyTitle: Observable<String?> {get set}
    var storyDescription: Observable<String?> {get set}

    var minTitleLength: Int {get}
    var maxTitleLength: Int {get}
    var minDescriptionLength: Int {get}

    var isValidStoryTitle: Observable<Bool> {get}
    var isValidStoryDescription: Observable<Bool> {get}

}
protocol AddStoryModelable: StoryModelable {
    func addStory(completion:@escaping (Bool) -> Void)
}

protocol EditStoryModelable: StoryModelable {
    var selectedStory: Story? {get set}
    func editStory(completion: @escaping (Bool) -> Void)

}
