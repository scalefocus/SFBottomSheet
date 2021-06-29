//
//  BottomSheetChildAppearance.swift
//  SFBottomSheet
//
//  Created by Aleksandar Gyuzelov on 28.06.21.
//

import UIKit

public struct BottomSheetChildAppearance {
    
    var containerHeight: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    var maximumAvailableHeightCoefficient: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    var minimumAvailableContainerHeight: CGFloat {
        didSet {
            updateHandler?(self)
        }
    }
    
    var updateHandler: ((BottomSheetChildAppearance) -> Void)?
    
    public init(containerHeight: CGFloat, minimumAvailableContainerHeight: CGFloat, maximumAvailableHeightCoefficient: CGFloat) {
        self.containerHeight = containerHeight
        self.minimumAvailableContainerHeight = minimumAvailableContainerHeight
        self.maximumAvailableHeightCoefficient = maximumAvailableHeightCoefficient
    }
    
}
