//
//  PopupTextFieldViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 18.02.21.
//

import UIKit

class PopupTextFieldViewController: UIViewController, SFBottomSheetChildControllerProtocol {

    private var viewModel: PopupErrorViewМodelProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var typeIconImageView: UIImageView!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 5
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.layer.borderColor = UIColor.black.cgColor
            actionButton.setTitleColor(.black, for: .normal)
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = actionButton.frame.height / 2
            actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
    @IBOutlet private weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    @objc dynamic var bottomSheetAppearanceSizes: BottomSheetChildAppearanceSizes!
    var didRequestCloseAction: (() -> Void)?
    private var initialContainerHeight: CGFloat = 200
    private var isKeyboardVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetAppearanceSizes = BottomSheetChildAppearanceSizes(containerHeight: initialContainerHeight,
                                                                     minimumAvailableContainerHeight: 100,
                                                                     maximumAvailableHeightCoefficient: 0.85)
        setup()
        
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(autoHideGestureTapped(gestureRecognizer:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func autoHideGestureTapped(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: nil)
        let matchingViews = view.descendants()
        .filter { $0.convert($0.bounds, to: nil).contains(location) }
        
        let textInputViews = matchingViews.filter { $0 is UITextView || $0 is UITextField }
        
        if textInputViews.isEmpty {
            view.endEditing(true)
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShowWithHeight(keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        isKeyboardVisible = false
        bottomSheetAppearanceSizes.containerHeight = initialContainerHeight
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func keyboardWillShowWithHeight(_ height: CGFloat) {
        guard !isKeyboardVisible else { return }
        bottomSheetAppearanceSizes.containerHeight += height
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
            strongSelf.scrollView.scrollToView(view: strongSelf.textField, animated: true)
            strongSelf.isKeyboardVisible = true
        }
    }
    
    // MARK: - Methods

    private func setup() {
        typeIconImageView.image = viewModel.typeIcon
        errorTitleLabel.text = viewModel.errorTitle
        
        switch viewModel.actionButtonType {
        case .none:
            actionButton.isHidden = true
        case .title(let title), .titleAndAction(let title, _):
            actionButton.setTitle(title, for: .normal)
        }
    }
    
    @objc private func didTapActionButton(sender: UIButton) {
        if case .title = viewModel.actionButtonType {
            didRequestCloseAction?()
        }
        viewModel.didTapActionButton()
    }
    
    // MARK: - Action
    
    @IBAction private func close(_ sender: Any) {
        didRequestCloseAction?()
    }
    
}

// MARK: - Scene Factory

extension PopupTextFieldViewController {
    static func createScene(message: PopupMessage) -> PopupTextFieldViewController? {
        let controller = PopupTextFieldViewController()
        let viewModel = PopupErrorViewModel(message: message)
        controller.viewModel = viewModel
        return controller
    }
}

extension UIScrollView {
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
}

extension UIView {
    func descendants() -> [UIView] {
        return subviews + subviews.flatMap { $0.descendants() }
    }
}
