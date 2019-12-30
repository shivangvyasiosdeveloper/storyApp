//
//  AddStoryViewController.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

enum Mode {
    case add
    case edit
}

protocol AddStoryViewControllerable {
    init(coordinator: Coordinator?, viewModel: AddStoryModelable?, mode: Mode)
}

class AddStoryViewController: UIViewController, AddStoryViewControllerable {
    private var mode: Mode
    private let coordinator: Coordinator?
    private let viewmodel: StoryModelable?

    required init(coordinator: Coordinator?, viewModel: AddStoryModelable?, mode: Mode) {
        self.coordinator = coordinator
        self.viewmodel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI elements
    private lazy var labelStoryTitle: UILabel = {
        let labelstoryTitle = UILabel.init()
        labelstoryTitle.backgroundColor = .clear
        labelstoryTitle.font = UIFont.boldSystemFont(ofSize: Constants.fontsize)
        labelstoryTitle.textColor = .systemBlue
        labelstoryTitle.textAlignment = .left
        labelstoryTitle.text = NSLocalizedString("LS_STORYTITLE", comment: "")

        return labelstoryTitle
    }()

    private lazy var textFieldstoryTitle: UITextField = {
        let textFieldstoryTitle = UITextField.init()
        textFieldstoryTitle.backgroundColor = .clear
        textFieldstoryTitle.delegate = self
        textFieldstoryTitle.font = UIFont.boldSystemFont(ofSize: Constants.fontsize)
        textFieldstoryTitle.textColor = .label
        textFieldstoryTitle.textAlignment = .left
        textFieldstoryTitle.placeholder = NSLocalizedString("LS_ENTERSTORYTITLE", comment: "")
        let borderColor: UIColor = .label
        textFieldstoryTitle.layer.borderWidth = Constants.borderWidth
        textFieldstoryTitle.layer.borderColor = borderColor.cgColor
        textFieldstoryTitle.layer.cornerRadius = Constants.corderRadius
        textFieldstoryTitle.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        return textFieldstoryTitle
    }()

    private lazy var labelStoryDescription: UILabel = {
        let labelStoryDescription = UILabel.init()
        labelStoryDescription.backgroundColor = .clear
        labelStoryDescription.font = UIFont.boldSystemFont(ofSize: Constants.fontsize)
        labelStoryDescription.textColor = .systemBlue
        labelStoryDescription.textAlignment = .left
        labelStoryDescription.text = NSLocalizedString("LS_STORYDESCRIPTION", comment: "")

        return labelStoryDescription
    }()

    private lazy var textViewstoryDescription: UITextView = {
        let textViewstoryDescription = UITextView.init()
        textViewstoryDescription.delegate = self
        textViewstoryDescription.backgroundColor = .clear
        textViewstoryDescription.font = UIFont.boldSystemFont(ofSize: Constants.fontsize)
        textViewstoryDescription.textColor = .label
        textViewstoryDescription.textAlignment = .left
        textViewstoryDescription.layer.borderWidth = Constants.borderWidth
        let borderColor: UIColor = .label
        textViewstoryDescription.layer.borderColor = borderColor.cgColor
        textViewstoryDescription.layer.cornerRadius = Constants.corderRadius
        return textViewstoryDescription
    }()

    private lazy var buttonSubmit: UIButton = {
        let buttonSubmit = UIButton.init()
        buttonSubmit.backgroundColor = .systemBlue
        buttonSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.fontsize)
        buttonSubmit.titleLabel?.textAlignment = .center
        buttonSubmit.setTitleColor(.systemGray, for: .disabled)
        buttonSubmit.setTitleColor(.systemBackground, for: .normal)
        buttonSubmit.layer.cornerRadius = Constants.corderRadius
        buttonSubmit.showsTouchWhenHighlighted = true
        buttonSubmit.setTitle(NSLocalizedString("LS_SUBMIT", comment: ""), for: .normal)
        return buttonSubmit
    }()

    // MARK: view life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        setInitialValues()
        customizeScreen()
        buildConstraints()
        bindViewModel()
    }

    // MARK: custom or ibaction methods
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setInitialValues() {
        self.title = NSLocalizedString("LS_ADDNEWSTORY", comment: "")
    }

    func customizeScreen() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(labelStoryTitle)
        self.view.addSubview(textFieldstoryTitle)
        self.view.addSubview(labelStoryDescription)
        self.view.addSubview(textViewstoryDescription)
        self.view.addSubview(buttonSubmit)
    }

    @objc func btnSubmitStoryTapped() {
    }
}

extension AddStoryViewController {
    func buildConstraints() {

        labelStoryTitle.translatesAutoresizingMaskIntoConstraints = false
        textFieldstoryTitle.translatesAutoresizingMaskIntoConstraints = false
        labelStoryDescription.translatesAutoresizingMaskIntoConstraints = false
        textViewstoryDescription.translatesAutoresizingMaskIntoConstraints = false
        buttonSubmit.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStoryTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(ConstraintConstants.startOffset)),
            labelStoryTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(ConstraintConstants.leadingOffset)),
            labelStoryTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-ConstraintConstants.trailingOffset)),
            labelStoryTitle.heightAnchor.constraint(equalToConstant: ConstraintConstants.defaultHeight),

            textFieldstoryTitle.topAnchor.constraint(equalTo: labelStoryTitle.bottomAnchor, constant: CGFloat(ConstraintConstants.topOffset)),
            textFieldstoryTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(ConstraintConstants.leadingOffset)),
            textFieldstoryTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-ConstraintConstants.trailingOffset)),
            textFieldstoryTitle.heightAnchor.constraint(equalToConstant: ConstraintConstants.defaultHeight),

            labelStoryDescription.topAnchor.constraint(equalTo: textFieldstoryTitle.bottomAnchor, constant: CGFloat(ConstraintConstants.topOffset)),
            labelStoryDescription.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(ConstraintConstants.leadingOffset)),
            labelStoryDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-ConstraintConstants.trailingOffset)),
            labelStoryDescription.heightAnchor.constraint(equalToConstant: ConstraintConstants.defaultHeight),

            textViewstoryDescription.topAnchor.constraint(equalTo: labelStoryDescription.bottomAnchor, constant: CGFloat(ConstraintConstants.topOffset)),
            textViewstoryDescription.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(ConstraintConstants.leadingOffset)),
            textViewstoryDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-ConstraintConstants.trailingOffset)),
            textViewstoryDescription.bottomAnchor.constraint(equalTo: buttonSubmit.topAnchor, constant: CGFloat(-ConstraintConstants.bottomOffset)),

            buttonSubmit.topAnchor.constraint(equalTo: textViewstoryDescription.bottomAnchor, constant: CGFloat(ConstraintConstants.topOffset)),
            buttonSubmit.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(ConstraintConstants.leadingOffset)),
            buttonSubmit.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-ConstraintConstants.trailingOffset)),
            buttonSubmit.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: CGFloat(-ConstraintConstants.endOffset))

        ])
    }
}

extension AddStoryViewController: UITextFieldDelegate {
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension AddStoryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
            return false
        }
        return true
    }
}

extension AddStoryViewController {
    func bindViewModel() {

        if let viewmodel = self.viewmodel {
            viewmodel.storyTitle.bidirectionalBind(to: textFieldstoryTitle.reactive.text)
            viewmodel.storyDescription.bidirectionalBind(to: textViewstoryDescription.reactive.text)

            viewmodel.isValidStoryTitle.map {$0 ? .label : .systemRed}.bind(to: textFieldstoryTitle.reactive.textColor)

            viewmodel.isValidStoryDescription.map {$0 ? .label : .systemRed}.bind(to: textViewstoryDescription.reactive.textColor)

            combineLatest(viewmodel.isValidStoryTitle, viewmodel.isValidStoryDescription) { isValidStoryTitle, isValidStoryDescription in
                return isValidStoryTitle && isValidStoryDescription
            }.bind(to: buttonSubmit.reactive.isEnabled)

            _ = buttonSubmit.reactive.tap
                .observeNext {_ in
                // save data to local db...
                    switch self.mode {
                    case .add:
                        if let viewmodel = viewmodel as? AddStoryModelable {
                            viewmodel.addStory { (_) in
                                self.coordinator?.goBackToHomeScreenAndRefetchAllData()
                            }
                        }
                    case .edit:
                        if let viewmodel = viewmodel as? EditStoryModelable {
                            viewmodel.editStory { (_) in
                                self.coordinator?.goBackToHomeScreenAndRefetchAllData()
                            }
                        }
                    }

            }
        }

    }

}
