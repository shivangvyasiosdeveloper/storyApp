//
//  StoryListViewController.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import UIKit

protocol StoryListViewControllerable {
    init(coordinator: Coordinator?, viewModel: StoryListViewModelable?)
}

class StoryListViewController: UIViewController, StoryListViewControllerable {
    private let coordinator: Coordinator?
    private var viewmodel: StoryListViewModelable?
    private var datasourceStoryList: StoryListDataSource?
    private var delegateStoryList: StoryListDelegate?
    var shouldFetchData = false

// MARK: Initializers
    required init(coordinator: Coordinator?, viewModel: StoryListViewModelable?) {
        self.coordinator = coordinator
        self.viewmodel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewmodel?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: IBOutlets
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    private lazy var barButtonAddStory: UIBarButtonItem = {
        let barButtonAddStory = UIBarButtonItem.init(title: NSLocalizedString("LS_ADDSTORY", comment: ""), style: .done, target: self, action: #selector(btnAddStoryTapped))
        return barButtonAddStory
    }()

    private lazy var barButtonClearAll: UIBarButtonItem = {
        let barButtonClearAll = UIBarButtonItem.init(title: NSLocalizedString("LS_CLEARALL", comment: ""), style: .done, target: self, action: #selector(btnClearAllStoriesTapped))
        return barButtonClearAll
    }()

// MARK: ViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitValues()
        setupCustomLayout()
        customizeNavigationBar()
        BuildConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStories()
    }
// MARK: Custom OR IBAction Methods
    func loadStories() {
        guard shouldFetchData else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.viewmodel?.getAllStories(completion: { (_) in
                DispatchQueue.main.async {
                    self.shouldFetchData = false
                    self.tableView.reloadData()
                }
            })
        }
    }

    func customizeNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = barButtonAddStory
        self.navigationItem.leftBarButtonItem = barButtonClearAll
    }

    func setupCustomLayout() {
        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(tableView)
    }

    func setupInitValues() {
        self.title = NSLocalizedString("LS_STORIES", comment: "")
        self.shouldFetchData = true
        if let viewmodel = viewmodel {
            datasourceStoryList = StoryListDataSource(viewmodel)
            delegateStoryList = StoryListDelegate(viewmodel)
            tableView.dataSource = datasourceStoryList
            tableView.delegate = delegateStoryList
        }
    }

    @objc func btnAddStoryTapped() {
        coordinator?.openNewStory()
    }

    @objc func btnClearAllStoriesTapped() {
        DispatchQueue.global(qos: .background).async {
            self.viewmodel?.removeAllStories {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension StoryListViewController {
    func BuildConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint .activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])

    }
}

extension StoryListViewController: StoryListViewModelDelegate {
    func OpenSelected(story: Story?) {
        if let story = story {
            self.coordinator?.openStory(story: story)
        }
    }
}
