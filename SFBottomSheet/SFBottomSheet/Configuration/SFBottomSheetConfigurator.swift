//
//  SFBottomSheetConfigurator.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 17.02.21.
//

import UIKit

public protocol SFBottomSheetConfigurable {
    
    // MARK: Content
    
    var contentViewBackgroundColor: UIColor { get }
    var childContainerLeadingDefaultConstraint: CGFloat { get }
    var childContainerTrailingDefaulConstraint: CGFloat { get }
    
    // MARK: Container
    
    var containerViewCornerRadius: CGFloat { get }
    
    // MARK: Draggable
    
    var draggableContainerHeightConstraint: CGFloat { get }
    var draggableContainerBottomConstraint: CGFloat { get }
    var draggableHeightConstraint : CGFloat { get }
    var draggableWidthConstraint: CGFloat { get }
    var draggableBackgroundColor: UIColor { get }
    var draggableAlpha: CGFloat { get }
    var draggableCornerRadius: CGFloat { get }
    var draggableMaskedCorners: CACornerMask { get }
    
}

public struct SFBottomSheetConfigurator: SFBottomSheetConfigurable {
    
    // MARK: Content
    
    public var contentViewBackgroundColor: UIColor = UIColor(red: 0,
                                                             green: 0,
                                                             blue: 0,
                                                             alpha: 0.4)
    public var childContainerLeadingDefaultConstraint: CGFloat = 16
    public var childContainerTrailingDefaulConstraint: CGFloat = 16
    
    // MARK: Container
    
    public var containerViewCornerRadius: CGFloat = 16
        
    // MARK: Draggable
    
    public var draggableContainerHeightConstraint: CGFloat = 30
    public var draggableContainerBottomConstraint: CGFloat = 0
    public var draggableHeightConstraint: CGFloat = 5
    public var draggableWidthConstraint: CGFloat = 40
    public var draggableBackgroundColor: UIColor = .white
    public var draggableAlpha: CGFloat = 1
    public var draggableCornerRadius: CGFloat = 2
    public var draggableMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    
    public init () {}
    
}
