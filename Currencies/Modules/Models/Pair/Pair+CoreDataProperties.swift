//
//  Pair+CoreDataProperties.swift
//  Currencies
//
//  Created by Artem Lytkin on 31/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//
//

import Foundation
import CoreData


extension Pair {
    
    @nonobjc public class func makePair(with context: NSManagedObjectContext, main: Currency, secondary: Currency, coefficient: Float) -> Pair {
        let pair = Pair(context: context)
        pair.main = main
        pair.secondary = secondary
        pair.coefficient = coefficient
        return pair
    }

    @nonobjc public class func makeFetchRequest(withPredicateFor property: Pair.PropertyNames? = nil,
                                                filterText: Currency? = nil) -> NSFetchRequest<Pair> {
        
        let fetchRequest = NSFetchRequest<Pair>(entityName: Pair.entityName)
        
        if let unwrappedProperty = property,
            let text = filterText {
            fetchRequest.predicate = NSPredicate(format: "\(unwrappedProperty.rawValue) = %@", text)
        }
        
        return fetchRequest
    }
    
    @nonobjc public class func makeEntity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: Pair.entityName, in: managedObjectContext)
    }
    
    @NSManaged public var coefficient: Float
    @NSManaged public var secondary: Currency
    @NSManaged public var main: Currency
}


//struct Pair {
//    let main: Currency
//    let secondary: Currency
//    let coefficient: Float
//}
