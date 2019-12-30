//
//  StoryTableCellable.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation

protocol StoryTableCellable {
    init(_ identifier: String)
    func setContent(_ at: Int, viewModel: StoryListViewModelable)
}
