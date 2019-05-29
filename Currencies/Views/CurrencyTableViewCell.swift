//
//  CurrencyTableViewCell.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
    public static var identifier: String {
        return String(describing: CurrencyTableViewCell.self)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var longNameLabel: UILabel!

    // MARK: - Interactions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let alpha: CGFloat = selected ? 0.5 : 1
        
        currencyImageView.alpha = alpha
        shortNameLabel.alpha = alpha
        longNameLabel.alpha = alpha
        
        self.contentView.backgroundColor = .white
    }
    
    // MARK: - Public
    
    public func configureWithCellModel(_ cellModel: CurrencyListCellViewModel) {
        currencyImageView?.image = UIImage(named: cellModel.titleText)
        shortNameLabel?.text = cellModel.titleText
        longNameLabel?.text = cellModel.decriptionText
    }
}
