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
    }}
