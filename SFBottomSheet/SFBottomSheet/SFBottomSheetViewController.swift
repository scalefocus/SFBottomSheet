//
//  SFBottomSheetViewController.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

public protocol SFBottomSheetChildControllerProtocol: UIViewController {
    var defaultContainerHeight: CGFloat { get set }
    var minimumAvailableContainerHeight: CGFloat { get }
    var maximumAvailableHeightCoefficient: CGFloat { get }
    var childContainerLeadingDefaultConstraint: CGFloat { get }
    
    func getContainerHeight(_ maximumAvailableContainerHeight: CGFloat) -> CGFloat
}

class SFBottomSheetViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.masksToBounds = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet private weak var childContainerView: UIView!
    @IBOutlet private weak var draggableContainerView: UIView!
    @IBOutlet private weak var draggableView: UIView!
    @IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var draggableContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var draggableContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var draggableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var draggableWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private let animationDuration: TimeInterval = 0.3
    private var originalPosition: CGPoint?
    private var currentPositionTouched: CGPoint?
    private var maximumAvailableContainerHeight: CGFloat!
    private var minimumAvailableContainerHeight: CGFloat = .zero
    fileprivate var childViewController: SFBottomSheetChildControllerProtocol?
    fileprivate var configurator: SFBottomSheetConfigurable?
    fileprivate var didFinishWithoutSelection: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
        setupGestures()
        configureScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.alpha = 1
        guard let childViewController = childViewController else { return }
        maximumAvailableContainerHeight = view.frame.height * childViewController.maximumAvailableHeightCoefficient
        containerViewHeightConstraint.constant = childViewController.getContainerHeight(maximumAvailableContainerHeight)
        minimumAvailableContainerHeight = childViewController.minimumAvailableContainerHeight
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Methods
    
    private func configureScene() {
        guard let configurator = configurator else { return }
        
        containerView.layer.cornerRadius = configurator.containerViewCornerRadius
        
        contentView.backgroundColor = configurator.contentViewBackgroundColor
        
        draggableContainerHeightConstraint.constant = configurator.draggableContainerHeightConstraint
        draggableContainerBottomConstraint.constant = configurator.draggableContainerBottomConstraint
        
        draggableHeightConstraint.constant = configurator.draggableHeightConstraint
        draggableWidthConstraint.constant = configurator.draggableWidthConstraint
        draggableView.backgroundColor = configurator.draggableBackgroundColor
        draggableView.layer.masksToBounds = true
        draggableView.layer.cornerRadius = configurator.draggableCornerRadius
        draggableView.layer.maskedCorners = configurator.draggableMaskedCorners
    }
    
    private func addChildViewController() {
        guard let childViewController = childViewController else { return }
        addChild(childViewController)
        childViewController.view.embed(in: childContainerView)
        childViewController.didMove(toParent: self)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeScene))
        contentView.addGestureRecognizer(tapGesture)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        draggableContainerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func closeSceneIfNeeded() {
        if containerViewHeightConstraint.constant <= minimumAvailableContainerHeight {
            closeScene()
        }
    }
    
    @objc private func closeScene() {
        dismiss(animated: true)
        didFinishWithoutSelection?()
    }
    
    @objc private func panAction(_ panGesture: UIPanGestureRecognizer) {
        guard let childViewController = childViewController else { return }
        switch panGesture.state {
        case .changed:
            let translation = panGesture.translation(in: view)
            var height = childViewController.defaultContainerHeight - translation.y
            height = height > maximumAvailableContainerHeight ? maximumAvailableContainerHeight : height
            height = height < minimumAvailableContainerHeight ? minimumAvailableContainerHeight : height
            containerViewHeightConstraint.constant = height
            if height <= minimumAvailableContainerHeight {
                panGesture.state = .ended
            }
        default:
            containerViewHeightConstraint.constant = containerViewHeightConstraint.constant > minimumAvailableContainerHeight ?
                                                                                            childViewController.defaultContainerHeight :
                                                                                            .zero
            UIView.animate(withDuration: animationDuration,
                           animations: { [weak self] in self?.view.layoutIfNeeded() },
                           completion: { [weak self] _ in self?.closeSceneIfNeeded() })
        }
    }
}

// MARK: - Scene Factory

extension SFBottomSheetViewController {
    static func createScene(child: SFBottomSheetChildControllerProtocol?,
                            configuration: SFBottomSheetConfigurable?,
                            didFinishWithoutSelection: (() -> Void)?) -> SFBottomSheetViewController? {
        let controller = SFBottomSheetViewController()
        controller.childViewController = child
        controller.configurator = configuration ?? SFBottomSheetConfigurator()
        controller.didFinishWithoutSelection = didFinishWithoutSelection
        return controller
    }
}

extension UIView {
    func embed(in container: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}