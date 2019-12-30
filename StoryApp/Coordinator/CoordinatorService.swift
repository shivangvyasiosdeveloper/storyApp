//
//  Coordinatorable.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinatorable {
    init(_ navigationController: UINavigationController)
    func start()
}
