//
//  StoryListDelegate.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

class StoryListDelegate: NSObject {
    private var viewmodel: StoryListViewModelable
    init(_ viewModel: StoryListViewModelable) {
        self.viewmodel = viewModel
    }
}

extension StoryListDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewmodel.getStoryAt(index: indexPath.row) { (story) in
            viewmodel.selectedStoryIndex = indexPath.row
            viewmodel.delegate?.OpenSelected(story: story)
        }
    }

}
