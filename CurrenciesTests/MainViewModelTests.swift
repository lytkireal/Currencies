//
//  CurrenciesTests.swift
//  CurrenciesTests
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import XCTest
@testable import Currencies
import CoreData

class MainViewModelTests: XCTestCase {

    var systemUnderTest: MainViewModel!
    var mockMainService: MockMainService!
    var coreDataTestingHelper: CoreDataTestingHelper!
    
    let firstShortName = "AUD"
    let secondShortName = "GBP"
    
    override func setUp() {
        super.setUp()
    
        mockMainService = MockMainService()
        systemUnderTest = MainViewModel(apiService: mockMainService)
        
        coreDataTestingHelper = CoreDataTestingHelper()
        coreDataTestingHelper.clearStorage(for: Pair.entityName)
    }

    override func tearDown() {
        
        mockMainService = nil
        systemUnderTest = nil
        
        super.tearDown()
    }

    func test_fetch_pair() {
        guard let firstCurrency = Currency(shortName: firstShortName),
            let secondCurrency = Currency(shortName: secondShortName) else {
            
                XCTAssert(false)
                return
        }
        
        systemUnderTest.fetchPair(first: firstCurrency, second: secondCurrency)
        XCTAssert(mockMainService.isFetchPairCalled)
    }
    
    func test_fetchPair_fail() {
        
        let error = APIError.noNetwork
     
        guard let firstCurrency = Currency(shortName: firstShortName),
            let secondCurrency = Currency(shortName: secondShortName) else {
                
                XCTAssert(false)
                return
        }
        
        systemUnderTest.fetchPair(first: firstCurrency, second: secondCurrency)
        
        mockMainService.fetchFail(error: error)
        
        XCTAssertEqual(systemUnderTest.alertMessage, error.rawValue)
    }
    
    func test_show_pairsScene() {
        guard let firstCurrency = Currency(shortName: firstShortName),
            let secondCurrency = Currency(shortName: secondShortName) else {
                
                XCTAssert(false)
                return
        }
        
        let expect = XCTestExpectation(description: "Alert message is shown")
        
        systemUnderTest.showPairListScreen = { [weak systemUnderTest] in
            guard let systemUnderTest = systemUnderTest else { return }

            XCTAssertFalse(systemUnderTest.isEmpty)
            expect.fulfill()
        }
        
        systemUnderTest.fetchPair(first: firstCurrency, second: secondCurrency)
        
        let pair = coreDataTestingHelper.stubPair()
        mockMainService.completePairs = [pair]
        
        mockMainService.fetchSuccess()
    }

}


class MockMainService: MainServiceProtocol {
    var isFetchPairCalled = false
    
    var completePairs: [Pair] = []
    var completeClosure: ( ([Pair]?, APIError?) -> Void )!
    
    func fetchPair(pairName: String, completion: @escaping ([Pair]?, APIError?) -> Void) {
        isFetchPairCalled = true
        completeClosure = completion
    }
    
    func fetchSuccess() {
        completeClosure(completePairs, nil)
    }
    
    func fetchFail(error: APIError?) {
        completeClosure(nil, error)
    }
}
