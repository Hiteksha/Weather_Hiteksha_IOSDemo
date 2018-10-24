//
//  Weather_Hiteksha_IOSDemoTests.swift
//  Weather_Hiteksha_IOSDemoTests
//
//  Created by Hiteksha G. Kathiriya on 20/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import XCTest
@testable import Weather_Hiteksha_IOSDemo

class Weather_Hiteksha_IOSDemoTests: XCTestCase {

    func testString()
    {
        let value = 3
        let CountValue = value.square()
        value
        XCTAssertEqual(CountValue, 9)
    }
    func testExample()
    {
        var helloword : String?
        XCTAssertNil(helloword)
        
        helloword = "Hello world"
        XCTAssertEqual(helloword, "Hello world1")
        
    }
    
}
