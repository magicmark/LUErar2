//
//  LUErar2Tests.swift
//  LUErar2Tests
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

// TODO: more tests

import Cocoa
import XCTest

class UnrarTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func checkPassword() {
        // This is an example of a functional test case.
        var operation = Unrar(file: "dsf", withPassword: "sdf")
        
        // Check initially it is false
        XCTAssert(!operation.badPassword)
        operation.parseCheckPassword("Checksum error in the encrypted file /Users/mark/Desktop/luerar/LUErar.rar. Corrupt file or wrong password.")
        // Should now be false
        XCTAssert(operation.badPassword)
        operation.parseCheckPassword("i like apples")
        // Should still be false
        XCTAssert(operation.badPassword)

        operation = Unrar(file: "dsf", withPassword: "sdf")
        operation.parseCheckPassword("i like apples")
        // Should be true
        XCTAssert(!operation.badPassword)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
