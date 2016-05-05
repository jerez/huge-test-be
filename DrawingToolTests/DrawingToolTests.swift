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

