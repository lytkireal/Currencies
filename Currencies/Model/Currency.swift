//
//  Currency.swift
//  Revolut
//
//  Created by Artem Lytkin on 20.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

struct Currency: Equatable {
    
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.shortName == rhs.shortName
    }
    
    var shortName: String
    var longName: String?
    var coefficient: Double
}
