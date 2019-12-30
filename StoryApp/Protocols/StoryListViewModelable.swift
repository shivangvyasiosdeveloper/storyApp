//
//  StoryListViewModelable.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import Bond

protocol StoryListViewDeletable {
    func removeAllStories(completion:@escaping () -> ())
    func removeStory(at: Int, completion: @escaping() -> ())
}
protocol StoryListViewGettable {
    func getStoryAt(index: Int, completion: ((Story?)) -> Void)
    func getAllStories(completion:@escaping ([Story]?) -> Void)
}


protocol StoryListViewModelable: StoryListViewGettable, StoryListViewDeletable {
    var selectedStoryIndex: Int? {get set}
    var delegate: StoryListViewModelDelegate?{get set}
    func getNoOfSections() -> Int
    func getNoOfStories() -> Int
}
