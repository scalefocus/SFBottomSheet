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
    
    // MARK: - Configurable
    
    func configureWith(_ data: SFBottomSheetTableViewCellModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        sutupBalance(balance: data.balance)
        setupIcon()
    }
    
    // MARK: - Methods
    
    private func setupIcon() {
        iconImageView.image = UIImage(named: "banking")
    }
    
    private func sutupBalance(balance: String?) {
        balanceLabel.text = "$\(balance ?? "")"
    }
    
}

struct SFBottomSheetTableViewCellModel {
    let title: String
    let description: String
    let balance: String
}
