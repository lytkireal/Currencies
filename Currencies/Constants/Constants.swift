//
//  AppDelegate.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No network. Check your network settings."
    case invalidSessionResponse = "Invalid session. Try again."
    case dataProcessingFailure = "Can't show currenies. Try later."
    case noDataManager = "App can't save pairs of currencies."
}

typealias TableViewRemoveRowsClosure = (_ removingIndexPaths:[IndexPath]) -> Void
typealias EmptyClosure = () -> Void
typealias ErrorClosure = (_ message: String) -> Void
typealias FetchPairValuesClosure = ( [PairPayload]?, _ error: APIError?) -> Void

typealias PairPayload = (main: Currency, secondary: Currency, coefficient: Float)

struct Network {
    static let host = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
    static let updatingInterval: TimeInterval = 1
}
