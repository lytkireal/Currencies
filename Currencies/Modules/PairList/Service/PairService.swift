//
//  PairsService.swift
//  Currencies
//
//  Created by Artem Lytkin on 31/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit
import CoreData

protocol PairServiceProtocol: class {
    func fetchNewValues(for pairNames: [String], completion: @escaping FetchPairValuesClosure)
    func savePairs(_ pairs: [Pair])
    func removePair(_ pair: Pair)
    func cancelRequests()
}

class PairService: PairServiceProtocol {
    
    private var managedObjectContext: NSManagedObjectContext? {
        get {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            return context
        }
    }
    
    private var dataTasks: [URLSessionDataTask] = []
    
    public func cancelRequests() {
        dataTasks.forEach {
            $0.cancel()
        }
        
        dataTasks.removeAll()
    }
    
    public func removePair(_ pair: Pair) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        let fetchRequest = Pair.makeFetchRequest(withPredicateFor: pair.main, secondary: pair.secondary)
        
        do {
            let pairs = try managedObjectContext.fetch(fetchRequest)
            for pair in pairs {
                print(pair)
                managedObjectContext.delete(pair)
            }
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save changes. \(error), \(error.userInfo)")
            }

        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    public func savePairs(_ pairs: [Pair]) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        let request = Pair.makeFetchRequest()
        
        do {
            let savedPairList = try managedObjectContext.fetch(request)
            
            for savedPair in savedPairList {
                for currentPair in pairs {
                    if currentPair == savedPair {
                        savedPair.coefficient = currentPair.coefficient
                        savedPair.main = currentPair.main
                        savedPair.secondary = currentPair.secondary
                    }
                }
            }
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save changes. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    public func fetchNewValues(for pairNames: [String], completion: @escaping FetchPairValuesClosure) {
        
        guard let firstPair = pairNames.first else { return }
        
        let otherPairs = pairNames.suffix(from: 0)
        
        var urlString = Network.host + "?pairs=\(firstPair)"
        
        // Separate into characters for sum in one string at bottom
        let pairsCharacters = otherPairs.flatMap {
            return "&pairs=" + $0
        }
        let pairsString = String(pairsCharacters)
        urlString += pairsString
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            guard let data = data,
                let self = self else {
                
                if let err = error as NSError? {
                    if err.code == -999 {
                        completion(nil, nil)
                    } else if err.code == 499 {
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
                
                let pairPayloadList = self.processFetchedPayload(pairsData)
                completion(pairPayloadList, nil)
                
            } catch {
                completion(nil, APIError.dataProcessingFailure)
            }
        }
        
        task.resume()
        dataTasks.append(task)
    }
    
    // MARK: - Private
    
    private func processFetchedPayload(_ payload: [String: Float]) -> [PairPayload] {
        var pairPayloadList: [PairPayload] = []
        for (pairName, coefficient) in payload {
            
            if let pairPaylaod = PairService.makePairPayload(from: pairName, coefficient: coefficient) {
                pairPayloadList.append(pairPaylaod)
            }
        }
        return pairPayloadList
    }
    
    // MARK: - Static
    
    private static func makePairPayload(from pairName: String, coefficient: Float) -> PairPayload? {
        let endIndexOfMainCurrencyName = pairName.index(pairName.startIndex, offsetBy: 2)
        let mainCurrencyName = String(pairName[pairName.startIndex...endIndexOfMainCurrencyName])
        let startIndexOfSecondaryCurrencyName = pairName.index(after: endIndexOfMainCurrencyName)
        let secondaryCurrencyName = String(pairName[startIndexOfSecondaryCurrencyName..<pairName.endIndex])
        
        guard let mainCurrency = Currency(shortName: mainCurrencyName),
            let secondaryCurrency = Currency(shortName: secondaryCurrencyName) else {
            return nil
        }
        
        let pairPayload = (main: mainCurrency, secondary: secondaryCurrency, coefficient: coefficient)
        
        return pairPayload
    }
}
