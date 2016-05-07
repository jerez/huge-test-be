//
//  ShapeTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool

class ShapeTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    
    override func tearDown() { super.tearDown() }
    
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
    
    func testShapeBuilder_rightProps() {
        let strategy = MockStrategy()
        let pair = (Coordinate(x: 1, y: 1),Coordinate(x: 3, y: 3))
        let subject = ConcreteShape(strategy:strategy, coordinatePair: pair, color: "w")
        XCTAssertEqual(subject.coordinates.a,  Coordinate(x: 1, y: 1))
        XCTAssertEqual(subject.coordinates.b,  Coordinate(x: 3, y: 3))
        XCTAssertEqual(subject.color, "w")
    }
    
    
    func testShapeBuilder_calls_strategy() {
        let strategy = MockStrategy()
        let pair = (Coordinate(x: 1, y: 1),Coordinate(x: 3, y: 3))
        let subject = ConcreteShape(strategy:strategy, coordinatePair: pair, color: "w")
        
        XCTAssertEqual(strategy.callCounter, 0)
        XCTAssertFalse(subject.plot!.isEmpty)
        XCTAssertGreaterThan(strategy.callCounter, 0)
    }
    
    class MockStrategy: PlotStrategy {
        var callCounter:Int = 0
        func buildPlot(coordinates: CoordinatePair) -> [Coordinate] {
            callCounter += 1
            return [
                Coordinate(x: 1, y: 1),
                Coordinate(x: 2, y: 1),
                Coordinate(x: 3, y: 1),
                Coordinate(x: 1, y: 2),
                Coordinate(x: 3, y: 2),
                Coordinate(x: 1, y: 3),
                Coordinate(x: 2, y: 3),
                Coordinate(x: 3, y: 3)
            ]
        }
    }
}
