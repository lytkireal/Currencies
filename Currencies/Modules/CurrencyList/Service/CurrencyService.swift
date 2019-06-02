//
//  AppDelegate.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

protocol CurrencyServiceProtocol {
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void)
}

class CurrencyService: CurrencyServiceProtocol {
    
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void) {
        if let url = Bundle.main.url(forResource: "currencies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<String>.self, from: data)
                
                let currencies = jsonData.compactMap {
                    return Currency(shortName: $0)
                }
                
                completion(currencies, nil)
            } catch {
                completion(nil, APIError.dataProcessingFailure)
            }
        }
    }
}
