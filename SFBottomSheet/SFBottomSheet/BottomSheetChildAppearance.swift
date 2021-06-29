//
//  BottomSheetChildAppearance.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 28.06.21.
//

import UIKit

public struct BottomSheetChildAppearance {
    
    public var containerHeight: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    public var maximumAvailableHeightCoefficient: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    public var minimumAvailableContainerHeight: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    public var updateHandler: ((BottomSheetChildAppearance) -> Void)?
    
    public init(containerHeight: CGFloat, minimumAvailableContainerHeight: CGFloat, maximumAvailableHeightCoefficient: CGFloat) {
        self.containerHeight = containerHeight
        self.minimumAvailableContainerHeight = minimumAvailableContainerHeight
        self.maximumAvailableHeightCoefficient = maximumAvailableHeightCoefficient
    }
    
}
