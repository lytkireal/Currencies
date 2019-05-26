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
}

protocol APIServiceProtocol {
    func fetchCurrenciesList(currencyName: String, completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void)
    
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]) -> Void)
}

class APIService: APIServiceProtocol {
    
    func loadCurrenciesList(completion: @escaping (_ currencies: [Currency]) -> Void) {
        if let url = Bundle.main.url(forResource: "currencies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<String>.self, from: data)
                
                let currencies = jsonData.map {
                    return Currency(shortName: $0)
                }
                
                completion(currencies)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchCurrenciesList(currencyName: String, completion: @escaping (_ currencies: [Currency]?, _ error: APIError?) -> Void) {
        
        let urlString = Network.host + "/latest?base=\(currencyName)"
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                
                if let err = error as NSError? {
                    if err.code == 499 {
                        completion(nil, APIError.invalidSessionResponse)
                    } else {
                        completion(nil, APIError.noNetwork)
                    }
                }
                
                return
            }
            
            print(String(data: data, encoding: .utf8))
        }
        
        task.resume()
    }
        
//        Alamofire.request(urlString,
//                          method: .get,
//                          parameters: ["base": currencyName],
//                          headers: nil)
//            .validate()
//            .responseJSON { (response) in
//                guard response.result.isSuccess,
//                    let value = response.result.value else {
//
//                        if let error = response.result.error as? AFError, error.responseCode == 499 {
//                            completion(nil, APIError.invalidSessionResponse)
//                        } else {
//                            completion(nil, APIError.noNetwork)
//                        }
//
//                        return
//                }
//
//                var currenciesList: [Currency] = JSON(value)["rates"].map { json in
//
//                    var currency = Currency(shortName: json.0, longName: nil, coefficient: json.1.doubleValue)
//
//                    for (key, value) in Constants.currencyShortAndLongNameChains {
//                        if currency.shortName == key {
//                            currency.longName = value
//                        }
//                    }
//
//                    return currency
//                }
//
//                let euroCurrency = Currency(shortName: currencyName, longName: Constants.currencyShortAndLongNameChains[currencyName], coefficient: 1)
//                currenciesList.insert(euroCurrency, at: 0)
//
//                completion(currenciesList, nil)
//        }
//
//    }
}
