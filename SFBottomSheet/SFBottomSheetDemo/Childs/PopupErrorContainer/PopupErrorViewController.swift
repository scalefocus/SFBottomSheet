//
//  PopupErrorViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

protocol PopupErrorViewМodelProtocol {

    var typeIcon: UIImage? { get }
    var errorTitle: String { get }
    var description: String { get }
    var actionButtonType: PupupButtonType { get }
    
    func didTapActionButton()
    
}

class PopupErrorViewController: UIViewController, SFBottomSheetChildControllerProtocol {
    
    weak var delegate: SFBottomSheetChildDelegate?

    private var viewModel: PopupErrorViewМodelProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var typeIconImageView: UIImageView!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.layer.borderColor = UIColor.black.cgColor
            actionButton.setTitleColor(.black, for: .normal)
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = actionButton.frame.height / 2
            actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
    
    // MARK: - Properties
    
    var defaultContainerHeight: CGFloat = 300
    var minimumAvailableContainerHeight: CGFloat = 100
    var maximumAvailableHeightCoefficient: CGFloat = 0.8
    var childContainerLeadingDefaultConstraint: CGFloat = 16
    var childContainerTrailingDefaulConstraint: CGFloat = 16
    private var maximumHeight: CGFloat = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMaximumHeight()
        setup()
        
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func getContainerHeight(_ maximumAvailableContainerHeight: CGFloat) -> CGFloat {
        defaultContainerHeight = min(maximumAvailableContainerHeight, defaultContainerHeight)
        return defaultContainerHeight
    }
    
    private func setupMaximumHeight() {
        maximumHeight = UIScreen.main.bounds.size.height * maximumAvailableHeightCoefficient
    }
    
    private func setupDescriptionTextView() {
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        let scrollViewContentHeight = scrollView.contentSize.height + 50
        
        defaultContainerHeight = min(scrollViewContentHeight, maximumHeight)
    }
    
    private func setup() {
        typeIconImageView.image = viewModel.typeIcon
        errorTitleLabel.text = viewModel.errorTitle
        descriptionTextView.text = viewModel.description
        setupDescriptionTextView()
        
        switch viewModel.actionButtonType {
        case .none:
            actionButton.isHidden = true
        case .title(let title), .titleAndAction(let title, _):
            actionButton.setTitle(title, for: .normal)
        }
    }
    
    @objc private func didTapActionButton(sender: UIButton) {
        if case .title = viewModel.actionButtonType {
            delegate?.childDidRequestClose()
        }
        viewModel.didTapActionButton()
    }
    
    // MARK: - Action
    
    @IBAction private func close(_ sender: Any) {
        delegate?.childDidRequestClose()
    }
    
}

// MARK: - Scene Factory

extension PopupErrorViewController {
    static func createScene(message: PopupMessage) -> PopupErrorViewController? {
        let controller = PopupErrorViewController()
        let viewModel = PopupErrorViewModel(message: message)
        controller.viewModel = viewModel
        return controller
    }
}
