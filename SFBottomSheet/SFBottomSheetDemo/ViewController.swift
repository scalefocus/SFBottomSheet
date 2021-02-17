//
//  ViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func openBottonSheet(with child: SFBottomSheetChildControllerProtocol) {
        guard let bottomSheet = SFBottomSheetViewController.createScene(child: child,
                                                                        didFinishWithoutSelection: nil) else { return }

        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .crossDissolve
        present(bottomSheet, animated: true)
    }
    
    // Actions
    
    @IBAction func didTapShowTableView(_ sender: Any) {
        guard let child = SFBottomSheetListSceneConfigurator.createScene() else { return }
        openBottonSheet(with: child)
    }
    
    @IBAction func didTapShowCollectionView(_ sender: Any) {
    }
    
    @IBAction func didTapShowTextField(_ sender: Any) {
    }
    
    @IBAction func didTapShowScrollView(_ sender: Any) {
        guard let child = PopupErrorViewController.createScene(message: PopupMessage(title: Constants.PopupError.title,
                                                                               message: Constants.PopupError.message,
                                                                               icon: .product,
                                                                               button: .title(Constants.PopupError.buttonTitle)))
        else { return }
        openBottonSheet(with: child)
    }
    
}
