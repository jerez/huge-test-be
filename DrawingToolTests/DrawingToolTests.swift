//
//  DrawingToolTests.swift
//  DrawingToolTests
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool


/// Uncategorized and generic Tests
class DrawingToolTests: XCTestCase {
    
    /**
     Simple test to check coordinate equality
     */
    func testCoordinateEquality() {
        let coordinateA = Coordinate(x:5, y:15)
        let coordinateB = Coordinate(x:5, y:15)
        XCTAssertEqual(coordinateA, coordinateB)
    }
    
    
    func testCoordinateInequality() {
        let coordinateA = Coordinate(x:5, y:15)
        let coordinateB = Coordinate(x:15, y:5)
        XCTAssertNotEqual(coordinateA, coordinateB)
    }

}

//Asserts to test Throwing exceptions

func XCTAssertThrows<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        try expression()
        XCTFail("No error to catch! - \(message)", file: file, line: line)
    } catch {
    }
}

func XCTAssertNoThrow<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        try expression()
    } catch let error {
        XCTFail("Caught error: \(error) - \(message)", file: file, line: line)
    }
}

