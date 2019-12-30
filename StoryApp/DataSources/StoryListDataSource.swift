//
//  StoryListDataSource.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

class StoryListDataSource: NSObject, UITableViewDataSource {
    private var viewmodel: StoryListViewModelable
    init(_ viewModel: StoryListViewModelable) {
        self.viewmodel = viewModel
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.getNoOfStories()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel.getNoOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = NSLocalizedString("LS_STORY", comment: "")
        var cell: StoryTableViewCell?

        if cell == nil {
            cell = StoryTableViewCell(cellIdentifier)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StoryTableViewCell
        }
        cell!.setContent(indexPath.row, viewModel: viewmodel)
        return cell!
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viewmodel.removeStory(at: indexPath.row) {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            }
        }
    }

}
