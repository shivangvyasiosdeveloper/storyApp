//
//  StoryTableViewCell.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import UIKit

/// define a font size for storycell for story list  screen
enum StoryCellConstants {
     static let fontsize: CGFloat = 30
}

class StoryTableViewCell: UITableViewCell {

    private var identifier: String

    required init(_ identifier: String) {
        self.identifier = identifier
        super.init(style: .default, reuseIdentifier: self.identifier)
        setupInitial()
    }

    private func setupInitial() {
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.textLabel?.textColor = .systemTeal
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: StoryCellConstants.fontsize)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension StoryTableViewCell: StoryTableCellable {

    func setContent(_ at: Int, viewModel: StoryListViewModelable) {
        viewModel.getStoryAt(index: at) { (story) in
            if let story = story {
                self.textLabel?.text = story.storyTitle
            }
        }
    }

}
