//
//  CoreDataTestingHelper.swift
//  CurrenciesTests
//
//  Created by macbook air on 02/06/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import XCTest
import CoreData
@testable import Currencies

class CoreDataTestingHelper {
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Currencies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func stubPair() -> Pair {
        let firstCurrency = Currency(shortName: "AUD")!
        let secondCurrency = Currency(shortName: "GBP")!
        
        let pair = Pair.makePair(with: mockPersistentContainer.viewContext, main: firstCurrency, secondary: secondCurrency, coefficient: 12.55)
        
        return pair
    }
    
    func numberOfItemsInPersistentStore(for entityName: String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let results = try! mockPersistentContainer.viewContext.fetch(request)
        return results.count
    }
    
    func clearStorage(for entityName: String) {
        let context = mockPersistentContainer.viewContext
        let fetchRequest = Pair.makeFetchRequest()
        do {
            let pairs = try context.fetch(fetchRequest)
            for pair in pairs {
                print(pair)
                context.delete(pair)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save changes. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let context = mockPersistentContainer.viewContext
//        let objs = try! context.fetch(fetchRequest)
//        for case let obj as NSManagedObject in objs {
//            context.delete(obj)
//        }
//        try! context.save()
    }
}
