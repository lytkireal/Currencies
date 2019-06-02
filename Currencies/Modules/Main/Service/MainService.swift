//
//  MainViewModel.swift
//  Currencies
//
//  Created by Artem Lytkin on 31/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit
import CoreData

protocol MainServiceProtocol: class {
    func fetchPair(pairName: String, completion: @escaping (_ pairs: [Pair]?, _ error: APIError?) -> Void)
}

class MainService: MainServiceProtocol {
    
    var managedObjectContext: NSManagedObjectContext? {
        get {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            return context
        }
    }
    
    func fetchPair(pairName: String, completion: @escaping (_ pairs: [Pair]?, _ error: APIError?) -> Void) {
        
        let urlString = Network.host + "?pairs=\(pairName)"
        
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
            
            let decoder = JSONDecoder()
            
            do {
                let pairsData = try decoder.decode(Dictionary<String, Float>.self, from: data)
                
                DispatchQueue.main.async {
                    var pairs: [Pair] = []
                    
                    guard let managedObjectContext = self.managedObjectContext else {
                        completion(nil, APIError.noDataManager)
                        return
                    }
                    
                    for (pairName, coefficient) in pairsData {
                        if let pair = MainService.makePair(from: pairName, coefficient: coefficient, context: managedObjectContext) {
                            
                            pairs.append(pair)
                        }
                    }
                    
                    self.savePairs()
                    completion(pairs, nil)
                }
            } catch {
                completion(nil, APIError.dataProcessingFailure)
            }
        }
        
        task.resume()
    }
    
    private func savePairs() {
        DispatchQueue.main.async {
            guard let managedObjectContext = self.managedObjectContext else { return }
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Static
    
    private static func makePair(from pairName: String, coefficient: Float, context: NSManagedObjectContext) -> Pair? {
        let endIndexOfMainCurrencyName = pairName.index(pairName.startIndex, offsetBy: 2)
        let mainCurrencyName = String(pairName[pairName.startIndex...endIndexOfMainCurrencyName])
        let startIndexOfSecondaryCurrencyName = pairName.index(after: endIndexOfMainCurrencyName)
        let secondaryCurrencyName = String(pairName[startIndexOfSecondaryCurrencyName..<pairName.endIndex])
        
        guard let mainCurrency = Currency(shortName: mainCurrencyName),
            let secondaryCurrency = Currency(shortName: secondaryCurrencyName) else {
                return nil
        }
        
        let pair = Pair.makePair(with: context, main: mainCurrency, secondary: secondaryCurrency, coefficient: coefficient)
        
        return pair
    }
}
