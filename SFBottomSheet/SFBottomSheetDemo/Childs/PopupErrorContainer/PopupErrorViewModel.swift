//
//  PopupErrorViewModel.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

class PopupErrorViewModel: PopupErrorViewМodelProtocol {
    
    // MARK: - Properties
    
    private let message: PopupMessage
    var typeIcon: UIImage?
    var errorTitle: String = ""
    var description: String = ""
    var actionButtonType: PupupButtonType
    
    init(message: PopupMessage) {
        self.message = message
        
        errorTitle = message.title
        description = message.message
        actionButtonType = message.button
        typeIcon = message.icon.image
    }
    
    // MARK: - PopupErrorViewМodelProtocol
    
    func didTapActionButton() {
        if case let .titleAndAction(_, action) = message.button {
            action()
        }
    }
    
}

struct PopupMessage {
    let title: String
    let message: String
    let icon: PopupIconType
    let button: PupupButtonType
}

enum PupupButtonType {
    case none
    case title(String)
    case titleAndAction(String, () -> Void)
}

enum PopupIconType {
    case product
    case technical
    case banking
    case custom(UIImage)
    
    var image: UIImage? {
        switch self {
        case .product:
            return UIImage(named: "product")
        case .technical:
            return UIImage(named: "technical")
        case .banking:
            return UIImage(named: "banking")
        case .custom(let image):
            return image
        }
    }
}
