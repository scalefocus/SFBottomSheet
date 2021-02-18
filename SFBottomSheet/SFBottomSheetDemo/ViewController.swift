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
    
    private func openBottonSheet(with child: SFBottomSheetChildControllerProtocol, configuration: SFBottomSheetConfigurable? = nil) {
        guard let bottomSheet = SFBottomSheetViewController.createScene(child: child,
                                                                        configuration: configuration,
                                                                        didFinishWithoutSelection: nil) else { return }

        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .crossDissolve
        present(bottomSheet, animated: true)
    }
    
    // Actions
    
    @IBAction private func didTapShowTableView(_ sender: Any) {
        guard let child = SFBottomSheetListSceneConfigurator.createScene() else { return }
        openBottonSheet(with: child)
    }
    
    @IBAction private func didTapShowCollectionView(_ sender: Any) {
        guard let child = SFBottomSheetGridSceneConfigurator.createScene() else { return }
        openBottonSheet(with: child)
    }
    
    @IBAction private func didTapShowTextField(_ sender: Any) {
        guard let child = PopupTextFieldViewController.createScene(message: PopupMessage(title: Constants.PopupError.title,
                                                                                         message: Constants.PopupError.message,
                                                                                         icon: .product,
                                                                                         button: .title(Constants.PopupError.buttonTitle)))
        else { return }
        openBottonSheet(with: child)
    }
    
    @IBAction private func didTapShowScrollView(_ sender: Any) {
        guard let child = PopupErrorViewController.createScene(message: PopupMessage(title: Constants.PopupError.title,
                                                                               message: Constants.PopupError.message,
                                                                               icon: .product,
                                                                               button: .title(Constants.PopupError.buttonTitle)))
        else { return }
        var configurator = SFBottomSheetConfigurator()
        configurator.draggableAlpha = 0.7
        configurator.contentViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        openBottonSheet(with: child, configuration: configurator)
    }
    
}
