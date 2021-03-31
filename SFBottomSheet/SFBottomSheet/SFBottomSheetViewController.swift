//
//  SFBottomSheetViewController.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

public class BottomSheetChildAppearanceSizes: NSObject {
    
    @objc dynamic var containerHeight: CGFloat
    @objc dynamic var maximumAvailableHeightCoefficient: CGFloat
    @objc dynamic var minimumAvailableContainerHeight: CGFloat
    
    init(containerHeight: CGFloat, minimumAvailableContainerHeight: CGFloat, maximumAvailableHeightCoefficient: CGFloat) {
        self.containerHeight = containerHeight
        self.minimumAvailableContainerHeight = minimumAvailableContainerHeight
        self.maximumAvailableHeightCoefficient = maximumAvailableHeightCoefficient
    }
    
}

@objc public protocol SFBottomSheetChildControllerProtocol: NSObjectProtocol where Self: UIViewController {
    
    @objc dynamic var bottomSheetAppearanceSizes: BottomSheetChildAppearanceSizes! { get }
    @objc dynamic var didRequestCloseAction: (() -> Void)? { get set }
    
}

public class SFBottomSheetViewController: UIViewController {
    
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
    @IBOutlet private weak var childContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var childContainerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggableContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggableContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggableWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private let animationDuration: TimeInterval = 0.3
    private var originalPosition: CGPoint?
    private var currentPositionTouched: CGPoint?
    private var maximumAvailableContainerHeight: CGFloat!
    private var minimumAvailableContainerHeight: CGFloat = .zero
    @objc fileprivate var childViewController: SFBottomSheetChildControllerProtocol?
    fileprivate var configurator: SFBottomSheetConfigurable?
    fileprivate var didFinishWithoutSelection: (() -> Void)?
    
    var token: NSKeyValueObservation?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupChildController()
        setupGestures()
        applyConfiguration()
        token = observe(\.childViewController?.bottomSheetAppearanceSizes.containerHeight,
                        options: [.old, .new]) { [weak self] object, change in
            guard let strongSelf = self else { return }
            strongSelf.updateLayoutBaseOn(childAppearance: strongSelf.childViewController?.bottomSheetAppearanceSizes)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayoutBaseOn(childAppearance: childViewController?.bottomSheetAppearanceSizes)
    }
    
    // MARK: - Methods
    
    private func setupChildController() {
        guard let childViewController = childViewController else { return }
        childViewController.didRequestCloseAction = { [weak self] in
            self?.closeScene()
        }
        
        embedChildController()
    }
    
    private func updateLayoutBaseOn(childAppearance: BottomSheetChildAppearanceSizes?) {
        guard let childAppearance = childAppearance else { return }
        contentView.alpha = 1
        maximumAvailableContainerHeight = view.frame.height * childAppearance.maximumAvailableHeightCoefficient
        let containerHeight = min(childAppearance.containerHeight, maximumAvailableContainerHeight)
        containerViewHeightConstraint.constant = containerHeight
        
        minimumAvailableContainerHeight = childAppearance.minimumAvailableContainerHeight
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func applyConfiguration() {
        guard let configurator = configurator else { return }
        
        containerView.layer.cornerRadius = configurator.containerViewCornerRadius
        childContainerLeadingConstraint.constant = configurator.childContainerLeadingDefaultConstraint
        childContainerTrailingConstraint.constant = configurator.childContainerTrailingDefaulConstraint
        
        contentView.backgroundColor = configurator.contentViewBackgroundColor
        
        draggableContainerHeightConstraint.constant = configurator.draggableContainerHeightConstraint
        draggableContainerBottomConstraint.constant = configurator.draggableContainerBottomConstraint
        
        draggableHeightConstraint.constant = configurator.draggableHeightConstraint
        draggableWidthConstraint.constant = configurator.draggableWidthConstraint
        draggableView.backgroundColor = configurator.draggableBackgroundColor
        draggableView.alpha = configurator.draggableAlpha
        draggableView.layer.masksToBounds = true
        draggableView.layer.cornerRadius = configurator.draggableCornerRadius
        draggableView.layer.maskedCorners = configurator.draggableMaskedCorners
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeScene))
        contentView.addGestureRecognizer(tapGesture)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        draggableContainerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func embedChildController() {
        guard let childViewController = childViewController else { return }
        addChild(childViewController)
        childViewController.view.embed(in: childContainerView)
        childViewController.didMove(toParent: self)
        
    }
    
    private func closeSceneIfNeeded() {
        if containerViewHeightConstraint.constant <= minimumAvailableContainerHeight {
            closeScene()
        }
    }
    
    @objc private func closeScene() {
        containerViewHeightConstraint.constant = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: []) {
            self.contentView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: true)
            self.didFinishWithoutSelection?()
        }
    }
    
    @objc private func panAction(_ panGesture: UIPanGestureRecognizer) {
        guard let childSizes = childViewController?.bottomSheetAppearanceSizes else { return }
        switch panGesture.state {
        case .changed:
            let translation = panGesture.translation(in: view)
            var height = childSizes.containerHeight - translation.y
            height = height > maximumAvailableContainerHeight ? maximumAvailableContainerHeight : height
            height = height < minimumAvailableContainerHeight ? minimumAvailableContainerHeight : height
            containerViewHeightConstraint.constant = height
            if height <= minimumAvailableContainerHeight {
                panGesture.state = .ended
            }
        default:
            containerViewHeightConstraint.constant = containerViewHeightConstraint.constant >
                minimumAvailableContainerHeight ? childSizes.containerHeight : .zero
            UIView.animate(withDuration: animationDuration,
                           animations: { [weak self] in self?.view.layoutIfNeeded() },
                           completion: { [weak self] _ in self?.closeSceneIfNeeded() })
        }
    }
}

// MARK: - Scene Factory

public extension SFBottomSheetViewController {
    static func createScene(child: SFBottomSheetChildControllerProtocol?,
                            configuration: SFBottomSheetConfigurable?,
                            didFinishWithoutSelection: (() -> Void)?) -> SFBottomSheetViewController? {
        
        let bundle = Bundle(for: self)
        let controller = SFBottomSheetViewController(nibName: "\(self)", bundle: bundle)
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
