//
//  SFBottomSheetConfigurator.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 17.02.21.
//

import UIKit

protocol SFBottomSheetConfigurable {
    
    // MARK: Content
    
    var contentViewBackgroundColor: UIColor { get }
    
    // MARK: Container
    
    var containerViewCornerRadius: CGFloat { get }
    
    // MARK: Draggable
    
    var draggableContainerHeightConstraint: CGFloat { get }
    var draggableContainerBottomConstraint: CGFloat { get }
    var draggableHeightConstraint : CGFloat { get }
    var draggableWidthConstraint: CGFloat { get }
    var draggableBackgroundColor: UIColor { get }
    var draggableCornerRadius: CGFloat { get }
    var draggableMaskedCorners: CACornerMask { get }
    
}

struct SFBottomSheetConfigurator: SFBottomSheetConfigurable {
    
    // MARK: Content
    
    var contentViewBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    // MARK: Container
    
    var containerViewCornerRadius: CGFloat = 16
        
    // MARK: Draggable
    
    var draggableContainerHeightConstraint: CGFloat = 30
    var draggableContainerBottomConstraint: CGFloat = 0
    var draggableHeightConstraint: CGFloat = 5
    var draggableWidthConstraint: CGFloat = 40
    var draggableBackgroundColor: UIColor = .white
    var draggableCornerRadius: CGFloat = 2
    var draggableMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
}
