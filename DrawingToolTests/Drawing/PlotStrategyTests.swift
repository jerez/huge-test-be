//
//  PlotStrategyTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest

@testable import DrawingTool

class PlotStrategyTests: XCTestCase {
    
    var subjectLine: LineStrategy?
    var subjectRect: RectStrategy?
    
    override func setUp() {
        super.setUp()
        subjectLine = LineStrategy()
        subjectRect = RectStrategy()
    }
    
    override func tearDown() { super.tearDown() }
    
    func testLineStratgy_Line_withoutZero() {
        let coords = (Coordinate(x: 0,y: 1), Coordinate(x: 0,y: 1))
        let out = subjectLine!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_Line_withoutZero_2() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 1,y: 0))
        let out = subjectLine!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_Line_valid() {
        let coords = (Coordinate(x: 6,y: 1), Coordinate(x: 1,y: 9))
        let out = subjectLine!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_createHorizontalLine_width() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 8,y: 1))
        let out = subjectLine!.buildPlot(coords)
        XCTAssertEqual(out.flatMap{$0}.count, 8)
    }
    
    func testLineStratgy_createVerticalLine_Height() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 1,y: 8))
        let out = subjectLine!.buildPlot(coords)
        XCTAssertEqual(out.flatMap{$0}.count, 8)
    }
    
    func testLineStratgy_horizontal_components() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 5,y: 1))
        let out = subjectLine!.buildPlot(coords).flatMap{$0}
        XCTAssertEqual(out[0], Coordinate(x: 1, y: 1))
        XCTAssertEqual(out[1], Coordinate(x: 2, y: 1))
        XCTAssertEqual(out[2], Coordinate(x: 3, y: 1))
        XCTAssertEqual(out[3], Coordinate(x: 4, y: 1))
        XCTAssertEqual(out[4], Coordinate(x: 5, y: 1))
    }
    
    func testLineStratgy_vertical_components() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 1,y: 5))
        let out = subjectLine!.buildPlot(coords).flatMap{$0}
        XCTAssertEqual(out[0], Coordinate(x: 1, y: 1))
        XCTAssertEqual(out[1], Coordinate(x: 1, y: 2))
        XCTAssertEqual(out[2], Coordinate(x: 1, y: 3))
        XCTAssertEqual(out[3], Coordinate(x: 1, y: 4))
        XCTAssertEqual(out[4], Coordinate(x: 1, y: 5))
    }
    
    func testLineStratgy_Rect_withoutZero() {
        let coords = (Coordinate(x: 0,y: 1), Coordinate(x: 0,y: 1))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_Rect_withoutZero_2() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 1,y: 0))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_createRect_pathSize() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 10,y: 8))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertEqual(out.count, 32)
    }
    
    func testLineStratgy_createRect_pathSize_2() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 23,y: 32))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertEqual(out.count, 106)
    }
    
    func testLineStratgy_try_rect_with_line_params() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 1,y: 10))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_try_rect_with_line_params_hrz() {
        let coords = (Coordinate(x: 5,y: 5), Coordinate(x: 15,y: 5))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertTrue(out.isEmpty)
    }
    
    func testLineStratgy_createRect_path_elements() {
        let coords = (Coordinate(x: 1,y: 1), Coordinate(x: 3,y: 3))
        let out = subjectRect!.buildPlot(coords)
        XCTAssertTrue(out.contains(Coordinate(x: 1, y: 1)))
        XCTAssertTrue(out.contains(Coordinate(x: 2, y: 1)))
        XCTAssertTrue(out.contains(Coordinate(x: 3, y: 1)))
        XCTAssertTrue(out.contains(Coordinate(x: 3, y: 2)))
        XCTAssertTrue(out.contains(Coordinate(x: 3, y: 3)))
        XCTAssertTrue(out.contains(Coordinate(x: 2, y: 3)))
        XCTAssertTrue(out.contains(Coordinate(x: 1, y: 3)))
        XCTAssertTrue(out.contains(Coordinate(x: 1, y: 2)))
        XCTAssertFalse(out.contains(Coordinate(x: 2, y: 2)))
    }
    
}
