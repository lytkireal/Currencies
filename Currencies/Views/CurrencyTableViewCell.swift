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

class CurrencyTableViewCell: UITableViewCell, UITextFieldDelegate {
    
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
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currencyIdentifier = currencyIdentifier else { return true }
        
        // 1
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        // 2
        if !newText.isEmpty {
            delegate?.currencyTableViewCellDelegate(currencyIdentifier, newValueOfCurrency: newText.replacingOccurrences(of: ",", with: "."))
        } else {
            delegate?.currencyTableViewCellDelegate(currencyIdentifier, newValueOfCurrency: "0")
        }
        
        return true
    }
    
    // MARK: - Public
    
    public func configureWithCellModel(_ cellModel: CurrencyListCellViewModel) {
        currencyImageView?.image = UIImage(named: cellModel.titleText)
        shortNameLabel?.text = cellModel.titleText
        longNameLabel?.text = cellModel.decriptionText
        currencyIdentifier = cellModel.titleText
        isHighlighted = cellModel.isSelected
        isSelected = cellModel.isSelected
    }
    
    // MARK: - Static
    
    public static func identifier() -> String {
        return String(describing: CurrencyTableViewCell.self)
    }
}
