//
//  AppDelegate.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

@objc(Currency)
public class Currency: NSObject, NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(shortName, forKey: "shortName")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        shortName = aDecoder.decodeObject(forKey: "shortName") as! String
    }
    
    public static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.shortName == rhs.shortName
    }
    
    let shortName: String
    var isSelected: Bool = false
    
    var longName: String {
        get {
            return getLongName(from: shortName)
        }
    }
    
    init?(shortName: String) {
        
        guard shortName.count == 3 else {
            return nil
        }
        
        let upperCase = CharacterSet.uppercaseLetters
        for char in shortName.unicodeScalars {
            if !upperCase.contains(char) {
                return nil
            }
        }
        
        guard getLongName(from: shortName) != "" else {
            return nil
        }
        
        self.shortName = shortName
    }
}

private func getLongName(from shortName: String) -> String {
    switch shortName {
    case "AUD":
        return "Australian Dollar"
    case "BGN":
        return "Bulgarian Lev"
    case "BRL":
        return "Brazilian Real"
    case "CAD":
        return "Canadian Dollar"
    case "CHF":
        return "Swiss Frank"
    case "CNY":
        return "Chinese Yuan Renminbi"
    case "CZK":
        return "Czech Koruna"
    case "DKK":
        return "Danish Krone"
    case "GBP":
        return "British Pound"
    case "HKD":
        return "Hong Kong Dollar"
    case "HRK":
        return "Croatian Kuna"
    case "HUF":
        return "Hungarian Forint"
    case "IDR":
        return "Indonesian Rupiah"
    case "ILS":
        return "Israeli Shekel"
    case "INR":
        return "Indian Rupee"
    case "ISK":
        return "Icelandic Krona"
    case "JPY":
        return "Japanese Yen"
    case "KRW":
        return "South Korean Won"
    case "MXN":
        return "Mexican Peso"
    case "MYR":
        return "Malaysian Ringgit"
    case "NOK":
        return "Norwegian Krone"
    case "NZD":
        return "New Zealand Dollar"
    case "PHP":
        return "Philippine Peso"
    case "PLN":
        return "Polish Zloty"
    case "RON":
        return "Romanian Leu"
    case "RUB":
        return "Russian Ruble"
    case "SEK":
        return "Swedish Krona"
    case "SGD":
        return "Singapore Dollar"
    case "THB":
        return "Thai Baht"
    case "TRY":
        return "Turkish Lira"
    case "USD":
        return "US Dollar"
    case "ZAR":
        return "South African Rand"
    case "EUR":
        return "Euro"
    default:
        return ""
    }
}
