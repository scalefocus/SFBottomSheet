//
//  SFBottomSheetGridCollectionViewCell.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 18.02.21.
//

import UIKit

class SFBottomSheetGridCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.black.cgColor
            containerView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configureWith(_ data: SFBottomSheetTableViewCellModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        iconImageView.image = UIImage(named: "banking")
        balanceLabel.text = "$\(data.balance)"
    }

}
