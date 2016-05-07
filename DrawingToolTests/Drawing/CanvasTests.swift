//
//  CanvasTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest

@testable import DrawingTool

class CanvasTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWidthOfCanvas() {
        let canvas = ConcreteCanvas(width: 10, height: 20)
        XCTAssertEqual(canvas!.width, 10)
    }
    
    func testHeightOfCanvas() {
        let canvas = ConcreteCanvas(width: 10, height: 20)
        XCTAssertEqual(canvas!.height, 20)
    }
    
    func testCanvasBuildsPlot() {
        let canvas = ConcreteCanvas(width: 20, height: 20)
        XCTAssertNotNil(canvas!.plot)
    }
    
    func testCanvasCreation_with_ZeroValues() {
        let canvas = ConcreteCanvas(width: 0, height: 0)
        XCTAssertNil(canvas)
    }
    
    func testCanvasCreationWithSize_1x1_() {
        let canvas = ConcreteCanvas(width: 1, height: 1)
        //Should create a plot of 3x3
        XCTAssertEqual(canvas!.plot.flatMap{$0}.count, 9)
    }
    
    func testCanvasCreationWithSize_40x28_() {
        let canvas = ConcreteCanvas(width: 40, height: 28)
        XCTAssertEqual(canvas!.plot.flatMap{$0}.count, 1260)
    }
    
    func testCanvasCreation_WithSize_2000x400_() {
        let canvas = ConcreteCanvas(width: 2000, height: 400)
        XCTAssertEqual(canvas!.plot.flatMap{$0}.count, 804804)
    }
    
    func testCoordFits_coord_thatFitsInCanvas() {
        let canvas = ConcreteCanvas(width: 10, height: 6)
        let coord = Coordinate(x: 4,y: 2)
        XCTAssertTrue(canvas!.fitInCanvas(coord))
    }
    
    func testCoordFits_coord_That_NoFitsInCanvas() {
        let canvas = ConcreteCanvas(width: 10, height: 4)
        let coord = Coordinate(x: 4,y: 6)
        XCTAssertFalse(canvas!.fitInCanvas(coord))
    }

    func testShapeFits_shape_that_FitsInCanvas() {
        let canvas = ConcreteCanvas(width: 10, height: 6)
        let shape = LineShapeMock()
        XCTAssertTrue(canvas!.shapeFits(shape))
    }
    
    
    func testShapeFits_shape_that_NoFitsInCanvas() {
        let canvas = ConcreteCanvas(width: 7, height: 4)
        let shape = LineShapeMock()
        XCTAssertFalse(canvas!.shapeFits(shape))
    }
    
    
    func testAddShape_shape_thatFits_noThrow (){
        let canvas = ConcreteCanvas(width: 10, height: 6)
        let shape = LineShapeMock()
        XCTAssertNoThrow(try canvas!.addShape(shape) )
    }
    
    func testAddShape_shapeThat_DoesntFits_Throw (){
        let canvas = ConcreteCanvas(width: 7, height: 4)
        let shape = LineShapeMock()
        XCTAssertThrowsError(try canvas!.addShape(shape) )
    }
    
    
    func testAddShape_shapeThatFits_PlotsLineShape (){
        let canvas = ConcreteCanvas(width: 10, height: 6)
        let shape = LineShapeMock()
        let plotBefore = canvas!.plot
        XCTAssertNotEqual(plotBefore[5][1], "o")
        XCTAssertNotEqual(plotBefore[5][2], "o")
        XCTAssertNotEqual(plotBefore[5][3], "o")
        XCTAssertNotEqual(plotBefore[5][4], "o")
        XCTAssertNotEqual(plotBefore[5][5], "o")
        XCTAssertNotEqual(plotBefore[5][6], "o")
        XCTAssertNotEqual(plotBefore[5][7], "o")
        XCTAssertNotEqual(plotBefore[5][8], "o")
        try! canvas!.addShape(shape)
        let plotAfter = canvas!.plot
        XCTAssertEqual(plotAfter[5][1], "o")
        XCTAssertEqual(plotAfter[5][2], "o")
        XCTAssertEqual(plotAfter[5][3], "o")
        XCTAssertEqual(plotAfter[5][4], "o")
        XCTAssertEqual(plotAfter[5][5], "o")
        XCTAssertEqual(plotAfter[5][6], "o")
        XCTAssertEqual(plotAfter[5][7], "o")
        XCTAssertEqual(plotAfter[5][8], "o")
    }
    
    func testAddShape_shapeThatNoFits_PlotsLineShape (){
        let canvas = ConcreteCanvas(width: 3, height: 3)
        let shape = LineShapeMock()
        let plotBefore = canvas!.plot
        XCTAssertEqual(plotBefore[1][1], " ")
        XCTAssertEqual(plotBefore[2][1], " ")
        XCTAssertEqual(plotBefore[3][1], " ")
        XCTAssertEqual(plotBefore[1][2], " ")
        XCTAssertEqual(plotBefore[2][2], " ")
        XCTAssertEqual(plotBefore[3][2], " ")
        XCTAssertEqual(plotBefore[1][3], " ")
        XCTAssertEqual(plotBefore[2][3], " ")
        XCTAssertEqual(plotBefore[3][3], " ")
        _ = try? canvas!.addShape(shape)
        let plotAfter = canvas!.plot
        XCTAssertEqual(plotAfter[1][1], " ")
        XCTAssertEqual(plotAfter[2][1], " ")
        XCTAssertEqual(plotAfter[3][1], " ")
        XCTAssertEqual(plotAfter[1][2], " ")
        XCTAssertEqual(plotAfter[2][2], " ")
        XCTAssertEqual(plotAfter[3][2], " ")
        XCTAssertEqual(plotAfter[1][3], " ")
        XCTAssertEqual(plotAfter[2][3], " ")
        XCTAssertEqual(plotAfter[3][3], " ")
    }
    
    
    func testAddShape_shapeThatFits_PlotsRectShape (){
        let canvas = ConcreteCanvas(width: 4, height: 4)
        let shape = RectShapeMock()
        let plotBefore = canvas!.plot
        XCTAssertEqual(plotBefore[1][1], " ")
        XCTAssertEqual(plotBefore[2][1], " ")
        XCTAssertEqual(plotBefore[3][1], " ")
        XCTAssertEqual(plotBefore[4][1], " ")
        XCTAssertEqual(plotBefore[1][2], " ")
        XCTAssertEqual(plotBefore[2][2], " ")
        XCTAssertEqual(plotBefore[3][2], " ")
        XCTAssertEqual(plotBefore[4][2], " ")
        XCTAssertEqual(plotBefore[1][3], " ")
        XCTAssertEqual(plotBefore[2][3], " ")
        XCTAssertEqual(plotBefore[3][3], " ")
        XCTAssertEqual(plotBefore[4][3], " ")
        XCTAssertEqual(plotBefore[1][4], " ")
        XCTAssertEqual(plotBefore[2][4], " ")
        XCTAssertEqual(plotBefore[3][4], " ")
        XCTAssertEqual(plotBefore[4][4], " ")

        try! canvas!.addShape(shape)
        let plotAfter = canvas!.plot
        XCTAssertEqual(plotAfter[1][1], "o")
        XCTAssertEqual(plotAfter[2][1], "o")
        XCTAssertEqual(plotAfter[3][1], "o")
        XCTAssertEqual(plotAfter[4][1], " ")
        XCTAssertEqual(plotAfter[1][2], "o")
        XCTAssertEqual(plotAfter[2][2], " ")
        XCTAssertEqual(plotAfter[3][2], "o")
        XCTAssertEqual(plotAfter[4][2], " ")
        XCTAssertEqual(plotAfter[1][3], "o")
        XCTAssertEqual(plotAfter[2][3], "o")
        XCTAssertEqual(plotAfter[3][3], "o")
        XCTAssertEqual(plotAfter[4][3], " ")
        XCTAssertEqual(plotAfter[1][4], " ")
        XCTAssertEqual(plotAfter[2][4], " ")
        XCTAssertEqual(plotAfter[3][4], " ")
        XCTAssertEqual(plotAfter[4][4], " ")
    }
    
    func testFillBucket (){
        let canvas = ConcreteCanvas(width: 4, height: 4)
        let shape = RectShapeMock()
        let plotBefore = canvas!.plot
        XCTAssertEqual(plotBefore[1][1], " ")
        XCTAssertEqual(plotBefore[2][1], " ")
        XCTAssertEqual(plotBefore[3][1], " ")
        XCTAssertEqual(plotBefore[4][1], " ")
        XCTAssertEqual(plotBefore[1][2], " ")
        XCTAssertEqual(plotBefore[2][2], " ")
        XCTAssertEqual(plotBefore[3][2], " ")
        XCTAssertEqual(plotBefore[4][2], " ")
        XCTAssertEqual(plotBefore[1][3], " ")
        XCTAssertEqual(plotBefore[2][3], " ")
        XCTAssertEqual(plotBefore[3][3], " ")
        
        try! canvas!.addShape(shape)
        try! canvas!.fillBucket(Coordinate(x: 2,y: 2), color: "c")
        let plotAfter = canvas!.plot
        XCTAssertEqual(plotAfter[1][1], "o")
        XCTAssertEqual(plotAfter[2][1], "o")
        XCTAssertEqual(plotAfter[3][1], "o")
        XCTAssertEqual(plotAfter[4][1], " ")
        XCTAssertEqual(plotAfter[1][2], "o")
        XCTAssertEqual(plotAfter[2][2], "c")
        XCTAssertEqual(plotAfter[3][2], "o")
        XCTAssertEqual(plotAfter[4][2], " ")
        XCTAssertEqual(plotAfter[1][3], "o")
        XCTAssertEqual(plotAfter[2][3], "o")
        XCTAssertEqual(plotAfter[3][3], "o")
    }
    
    func testFillBucket_Recursive (){
        let canvas = ConcreteCanvas(width: 4, height: 4)
        let shape = RectShapeMock()
        let plotBefore = canvas!.plot
        XCTAssertEqual(plotBefore[1][1], " ")
        XCTAssertEqual(plotBefore[2][1], " ")
        XCTAssertEqual(plotBefore[3][1], " ")
        XCTAssertEqual(plotBefore[4][1], " ")
        XCTAssertEqual(plotBefore[1][2], " ")
        XCTAssertEqual(plotBefore[2][2], " ")
        XCTAssertEqual(plotBefore[3][2], " ")
        XCTAssertEqual(plotBefore[4][2], " ")
        XCTAssertEqual(plotBefore[1][3], " ")
        XCTAssertEqual(plotBefore[2][3], " ")
        XCTAssertEqual(plotBefore[3][3], " ")
        XCTAssertEqual(plotBefore[4][3], " ")
        XCTAssertEqual(plotBefore[1][4], " ")
        XCTAssertEqual(plotBefore[2][4], " ")
        XCTAssertEqual(plotBefore[3][4], " ")
        XCTAssertEqual(plotBefore[4][4], " ")
        
        try! canvas!.addShape(shape)
        try! canvas!.fillBucket(Coordinate(x: 4,y: 4), color: "c")
        let plotAfter = canvas!.plot
        XCTAssertEqual(plotAfter[1][1], "o")
        XCTAssertEqual(plotAfter[2][1], "o")
        XCTAssertEqual(plotAfter[3][1], "o")
        XCTAssertEqual(plotAfter[4][1], "c")
        XCTAssertEqual(plotAfter[1][2], "o")
        XCTAssertEqual(plotAfter[2][2], " ")
        XCTAssertEqual(plotAfter[3][2], "o")
        XCTAssertEqual(plotAfter[4][2], "c")
        XCTAssertEqual(plotAfter[1][3], "o")
        XCTAssertEqual(plotAfter[2][3], "o")
        XCTAssertEqual(plotAfter[3][3], "o")
        XCTAssertEqual(plotAfter[4][3], "c")
        XCTAssertEqual(plotAfter[1][4], "c")
        XCTAssertEqual(plotAfter[2][4], "c")
        XCTAssertEqual(plotAfter[3][4], "c")
        XCTAssertEqual(plotAfter[4][4], "c")
    }
    
    func testFillBucket_coordThatNoFitsInCanvas_Throw (){
        let canvas = ConcreteCanvas(width: 4, height: 4)
        let shape = LineShapeMock()
        XCTAssertThrows(try canvas!.addShape(shape) )
    }
    
    func testPerformanceOfAVeryBigCanvas() {
        // This is an example of a performance test case.
        self.measureBlock {
            ConcreteCanvas(width: 10000, height: 2000)!.plot
        }
    }
    
    struct LineShapeMock: Shape {
        var color: Character { get { return "o"} set {} }
        var coordinates: CoordinatePair {
            get { return (plot!.first!, plot!.last!)}
        }
        var plot:[Coordinate]? {
            get{
                return [
                    Coordinate(x: 1, y: 5),
                    Coordinate(x: 2, y: 5),
                    Coordinate(x: 3, y: 5),
                    Coordinate(x: 4, y: 5),
                    Coordinate(x: 5, y: 5),
                    Coordinate(x: 6, y: 5),
                    Coordinate(x: 7, y: 5),
                    Coordinate(x: 8, y: 5)
                ]
            }
        }
    }
    struct RectShapeMock: Shape {
        var color: Character { get { return "o"} set {} }
        var coordinates: CoordinatePair {
            get { return (plot!.first!, plot!.last!)}
        }
        var plot:[Coordinate]? {
            get{
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
    
    
}
