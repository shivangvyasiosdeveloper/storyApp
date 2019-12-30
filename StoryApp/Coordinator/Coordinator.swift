//
//  Coordinator.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

class Coordinator: Coordinatorable {
    private var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if(Thread.isMainThread){
            let storyListViewModel = StoryListViewModel()
            let storyListViewController = StoryListViewController.init(coordinator: self, viewModel: storyListViewModel)
            navigationController.pushViewController(storyListViewController, animated: false)
        }else{
            DispatchQueue.main.async {
                self.start()
            }
        }
    }
    
    func openStory(story: Story?){
        if(Thread.isMainThread){
            let openstoryviewmodel = AddEditStoryViewModel()
            openstoryviewmodel.selectedStory = story
            openstoryviewmodel.storyTitle.value = story?.storyTitle
            openstoryviewmodel.storyDescription.value = story?.storyDescription
            let addStoryViewController = AddStoryViewController.init(coordinator: self, viewModel: openstoryviewmodel, mode: .edit)
            self.navigationController.pushViewController(addStoryViewController, animated: true)
        }else{
            DispatchQueue.main.async {
                self.openStory(story: story)
            }
        }
    }
    
    func openNewStory(){
        if(Thread.isMainThread){
            let addstoryviewmodel = AddEditStoryViewModel()
            let addStoryViewController = AddStoryViewController.init(coordinator: self, viewModel: addstoryviewmodel, mode: .add)
            self.navigationController.pushViewController(addStoryViewController, animated: true)
        }else{
            DispatchQueue.main.async {
                self.openNewStory()
            }
        }
    }
    
    func goBackToHomeScreenAndRefetchAllData(){
        if(Thread.isMainThread){
            let storylistvc = self.navigationController.viewControllers.first as? StoryListViewController
            if let storylistvc = storylistvc{
                storylistvc.shouldFetchData = true
            }
            self.navigationController.popToRootViewController(animated: true)
        }else{
            DispatchQueue.main.async {
                self.goBackToHomeScreenAndRefetchAllData()
            }
        }
    }
    
}
