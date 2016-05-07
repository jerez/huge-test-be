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
class DrawingToolTests: XCTestCase {}



//Wrappers for Exception tests
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

