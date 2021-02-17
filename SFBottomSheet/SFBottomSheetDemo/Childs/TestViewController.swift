//
//  TestViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

class TestViewController: UIViewController, SFBottomSheetChildControllerProtocol {
    
    var defaultContainerHeight: CGFloat = 300
    
    var minimumAvailableContainerHeight: CGFloat = 50
    
    var maximumAvailableHeightCoefficient: CGFloat = 500
    
    var childContainerLeadingDefaultConstraint: CGFloat = 16
    
    func getContainerHeight(_ maximumAvailableContainerHeight: CGFloat) -> CGFloat {
        return defaultContainerHeight
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - Scene Factory

extension TestViewController {
    static func createScene() -> TestViewController? {
        let controller = TestViewController()
        return controller
    }
}
