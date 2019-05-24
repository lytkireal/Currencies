//
//  Constants.swift
//  Revolut
//
//  Created by Artem Lytkin on 20.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

struct Network {
    static let host = "https://revolut.duckdns.org"
}

class CurrencyManager {
    
    static let sharedInstance = CurrencyManager()
    
    private let currencyNameChains = [
        "AUD": "Australian Dollar",
        "BGN": "Bulgarian Lev",
        "BRL": "Brazilian Real",
        "CAD": "Canadian Dollar",
        "CHF": "Swiss Frank",
        "CNY": "Chinese Yuan Renminbi",
        "CZK": "Czech Koruna",
        "DKK": "Danish Krone",
        "GBP": "British Pound",
        "HKD": "Hong Kong Dollar",
        "HRK": "Croatian Kuna",
        "HUF": "Hungarian Forint",
        "IDR": "Indonesian Rupiah",
        "ILS": "Israeli Shekel",
        "INR": "Indian Rupee",
        "ISK": "Icelandic Krona",
        "JPY": "Japanese Yen",
        "KRW": "South Korean Won",
        "MXN": "Mexican Peso",
        "MYR": "Malaysian Ringgit",
        "NOK": "Norwegian Krone",
        "NZD": "New Zealand Dollar",
        "PHP": "Philippine Peso",
        "PLN": "Polish Zloty",
        "RON": "Romanian Leu",
        "RUB": "Russian Ruble",
        "SEK": "Swedish Krona",
        "SGD": "Singapore Dollar",
        "THB": "Thai Baht",
        "TRY": "Turkish Lira",
        "USD": "US Dollar",
        "ZAR": "South African Rand",
        "EUR": "Euro"
    ]
    
    subscript(currencyShortName: String) -> String? {
        return currencyNameChains[currencyShortName]
    }
}
