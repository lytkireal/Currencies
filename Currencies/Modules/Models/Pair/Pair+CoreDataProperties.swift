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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pair> {
        return NSFetchRequest<Pair>(entityName: "Pair")
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
