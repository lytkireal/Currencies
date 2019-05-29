//
//  PairTableViewCell.swift
//  Currencies
//
//  Created by Artem Lytkin on 29/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class PairTableViewCell: UITableViewCell {

    // MARK: - Static
    
    public static var identifier: String {
        return String(describing: PairTableViewCell.self)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    // MARK: - Public
    
    public func configureWithCellModel(_ cellModel: PairListCellViewModel) {
        titleTextLabel.text = cellModel.titleText
        descriptionTextLabel.text = cellModel.decriptionText
        valueLabel.text = cellModel.value
        secondaryTextLabel.text = cellModel.secondaryText
    }
}
