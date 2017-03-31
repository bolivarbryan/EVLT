//
//  EVLT_SwiftTests.swift
//  EVLT-SwiftTests
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import XCTest
@testable import EVLT_Swift

class EVLT_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testClientFormattedLastName_ShouldReturnUppdercased() {
        let client = Client(name: "mario", lastName: "bross", clientID: "0", commercialActiveString: "active", commercial: "active")
        let expectedValue = "BROSS"
        
        XCTAssertEqual(client.formattedLastName, expectedValue)
    }
    
    func testClientFormattedLastName_ShouldReturnUppdercased2() {
        let client = Client(name: "emmanuel", lastName: "levasseur", clientID: "0", commercialActiveString: "active", commercial: "active")
        let expectedValue = "LEVASSEUR"
        
        XCTAssertEqual(client.formattedLastName, expectedValue)
    }

    func testSAVInit_ShouldSetDescription() {
        let history = History(historyDescription: "History test")
        XCTAssertEqual(history.historyDescription, "History test")
    }
    
    func testSAVInit_ShouldSetDescriptionAndDateAndPrice() {
        let history = History(historyDescription: "History test", timestamp: 0.0, price: 150)
        XCTAssertEqual(history.timestamp, 0.0, "TimeStamp should be 0.0")
    }
 
    func testHistoryDate_ShouldReturnAValidFormat() {
        let history = History(historyDescription: "History test", timestamp: 1490989474 , price: 150)
        XCTAssertEqual(history.date, "31/03/2017")
    }
    
    func testHistoryPrice_shouldBeReturnedWithCurrency() {
        let history = History(historyDescription: "History test", timestamp: 1490989474 , price: 150)
        XCTAssertEqual(history.formattedPrice(), "€150")
    }
    
    func testSAVInit_ShouldSetPaymentTrueStatus() {
        let history = History(historyDescription: "History test", isPaid: true)
        XCTAssertEqual(history.isPaid, true)
    }
    
    func testHistoryDescription_ShouldReturnDescriptionAndDateAndPriceAndPaymentStatus() {
        let history = History(historyDescription: "History test", timestamp: 1490989474 , price: 150, isPaid: true)
        XCTAssertEqual(history.formattedDescription(), "History test le 31/03/2017 €150")

    }
}
