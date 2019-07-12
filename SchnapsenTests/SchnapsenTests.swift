//
//  SchnapsenTests.swift
//  SchnapsenTests
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import XCTest
@testable import Schnapsen

class SchnapsenTests: XCTestCase {

    var game: Schnapsen!
    
    override func setUp() {
        super.setUp()
        game = Schnapsen()
        
        
    
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        game = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }

}
