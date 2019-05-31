//
//  APIService.swift
//  Revolut
//
//  Created by Artem Lytkin on 27.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No network. Check your network settings."
    case invalidSessionResponse = "Invalid session. Try again."
    case dataProcessingFailure = "Can't show currenies. Try later."
}

protocol APIServiceProtocol {
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void)
}

protocol PairsServiceProtocol {
    func fetchPairsList(pairNames: [String], completion: @escaping (_ pairs: [Pair]?, _ error: APIError?) -> Void)
}

class CurrenciesService: APIServiceProtocol {
    
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void) {
        if let url = Bundle.main.url(forResource: "currencies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<String>.self, from: data)
                
                let currencies = jsonData.map {
                    return Currency(shortName: $0)
                }
                
                completion(currencies, nil)
            } catch {
                if let err = error as NSError? {
                    if err.code == 499 {
                        completion(nil, APIError.invalidSessionResponse)
                    } else {
                        completion(nil, APIError.noNetwork)
                    }
                }
            }
        }
    }
}
