//
//  Pair+CoreDataClass.swift
//  Currencies
//
//  Created by Artem Lytkin on 31/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pair)
public class Pair: NSManagedObject {
    
    public static func ==(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.main == rhs.main && lhs.secondary == rhs.secondary
    }
    
    public enum PropertyNames: String {
        case main = "main"
        case secondary = "secondary"
    }
    
    static var entityName: String {
        return String(describing: Pair.self)
    }
}
