//
//  SFBottomSheetListTableViewCell.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 17.02.21.
//

import UIKit

class SFBottomSheetListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var balanceLabel: UILabel!
    
    func configureWith(_ data: SFBottomSheetTableViewCellModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        iconImageView.image = UIImage(named: "banking")
        balanceLabel.text = "$\(data.balance)"
    }
    
}

struct SFBottomSheetTableViewCellModel {
    let title: String
    let description: String
    let balance: String
}
