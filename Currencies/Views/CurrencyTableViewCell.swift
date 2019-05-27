//
//  CurrencyTableViewCell.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

protocol CurrencyTableViewCellDelegate: class {
    func currencyTableViewCellDelegate(_ currencyShortName: String, newValueOfCurrency: String)
    func currencyValueDidBeginEditing()
}

class CurrencyTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var longNameLabel: UILabel!
    
    var currencyIdentifier: String?
    
    // MARK: - Properties
    
    weak var delegate: CurrencyTableViewCellDelegate?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Layout
    
    // MARK: - Public
    
    public func configureWithCellModel(_ cellModel: CurrencyListCellViewModel) {
        currencyImageView?.image = UIImage(named: cellModel.titleText)
        shortNameLabel?.text = cellModel.titleText
        longNameLabel?.text = cellModel.decriptionText
        currencyIdentifier = cellModel.titleText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected")
        
        let alpha: CGFloat = selected ? 0.5 : 1
        
        currencyImageView.alpha = alpha
        shortNameLabel.alpha = alpha
        longNameLabel.alpha = alpha
        
        self.contentView.backgroundColor = .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
//
//        let alpha: CGFloat = highlighted ? 0.5 : 1
//
//        currencyImageView.alpha = alpha
//        shortNameLabel.alpha = alpha
//        longNameLabel.alpha = alpha
//
//        if highlighted {
//            self.selectedBackgroundView?.backgroundColor = nil
//        }
    }
    
    // MARK: - Static
    
    public static func identifier() -> String {
        return String(describing: CurrencyTableViewCell.self)
    }
}
