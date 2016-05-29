//
//  CommandTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool

class CommandTests: XCTestCase {
    
    var drawer: MockDrawerReceiver?
    var canvas: MockCanvas?
    
    override func setUp() {
        super.setUp()
        drawer = MockDrawerReceiver()
    }
    
    override func tearDown() { super.tearDown() }
    
    func testCreateCanvas_Command() {
        let input = Input(type: InputType.CreateCanvas, params: [uint(2),uint(3)], instruction: "")
        let subject = CreateCanvasCommand(input: input)
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.setCanvasCallCounter, 1)
    }
    
    func testCreateCanvas_Command_wrongInput() {
        let input = Input(type: InputType.CreateLine, params: [uint(2),uint(3)], instruction: "")
        let subject = CreateCanvasCommand(input: input)
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 2)
        XCTAssertEqual(drawer!.setCanvasCallCounter, 0)
    }
    
    func testCreateCanvas_Command_wrongArgs_1() {
        let input = Input(type: InputType.CreateCanvas, params: [uint(1)], instruction: "")
        let subject = CreateCanvasCommand(input: input)
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 2)
        XCTAssertEqual(drawer!.setCanvasCallCounter, 0)
    }
    
    func testCreateCanvas_Command_wrongArgs_2() {
        let input = Input(type: InputType.CreateCanvas, params: [uint(1),uint(1),uint(1)], instruction: "")
        let subject = CreateCanvasCommand(input: input)

        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 2)
        XCTAssertEqual(drawer!.setCanvasCallCounter, 0)
    }
    
    func testCreateShape_Command_withLine() {
        let input = Input(type: InputType.CreateLine, params: [uint(2),uint(3), uint(3),uint(3)], instruction: "")
        let subject = AddShapeCommand(input: input, strategy: MockStrategy())
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.drawInCanvasCallCounter, 1)
    }
    
    func testCreateShape_Command_withRect() {
        let input = Input(type: InputType.CreateRect, params: [uint(2),uint(3), uint(4),uint(4)], instruction: "")
        let subject = AddShapeCommand(input: input, strategy: MockStrategy())
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.drawInCanvasCallCounter, 1)
    }
    
    func testCreateShape_Command_withDiagonal() {
        let input = Input(type: InputType.CreateDiagonal, params: [uint(1),uint(1), uint(3),uint(3)], instruction: "")
        let subject = AddShapeCommand(input: input, strategy: MockStrategy())
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.drawInCanvasCallCounter, 1)
    }
    
    
    func testCreateShape_Command_wrongInput() {
        let input = Input(type: InputType.CreateCanvas, params: [uint(2),uint(3), uint(2),uint(3)], instruction: "")
        let subject = AddShapeCommand(input: input, strategy: MockStrategy())
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.drawInCanvasCallCounter, 0)
    }

    
    func testFillCanvas_Command() {
        let input = Input(type: InputType.BucketFill, params: [uint(2),uint(3), Character("a")], instruction: "")
        let subject = BucketFillCommand(input: input)
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 1)
        XCTAssertEqual(drawer!.fillCanvasCallCounter, 1)
    }
    
    func testFillCanvas_Command_wrongInput() {
        let input = Input(type: InputType.CreateLine, params: [uint(2),uint(3), Character("a")], instruction: "")
        let subject = BucketFillCommand(input: input)
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 2)
        XCTAssertEqual(drawer!.fillCanvasCallCounter, 0)
    }
    
    func testFillCanvas_Command_wrongArgs() {
        let input = Input(type: InputType.BucketFill, params: [uint(1),uint(1),uint(1),uint(1)], instruction: "")
        let subject = BucketFillCommand(input: input)
        
        subject.execute(drawer!)
        
        XCTAssertEqual(drawer!.logCallCounter, 2)
        XCTAssertEqual(drawer!.fillCanvasCallCounter, 0)
    }

    
    class MockDrawerReceiver: Drawer {
        var logCallCounter: Int = 0
        var setCanvasCallCounter: Int = 0
        var drawInCanvasCallCounter: Int = 0
        var fillCanvasCallCounter: Int = 0
        
        func setCanvas(canvas: Canvas){ setCanvasCallCounter += 1}
        var canvas: Canvas? { get { return self.canvas } }
        
        func logCommand(entry: String){ logCallCounter += 1}
        
        func setOutputBuffer(buffer: OutputBuffer){ }
        
        func drawInCanvas(shape: Shape){ drawInCanvasCallCounter += 1 }
        
        func fillCanvasBucket(point: Coordinate, color:Character){ fillCanvasCallCounter += 1}
    }
    
    struct MockCanvas: Canvas{
        
        init?(width: uint, height: uint){}
        var width: uint { get { return 20} }
        var height: uint{ get{ return 4} }
        var plot: [[Character]] { get{ return[]} }
        
        func shapeFits(shape: Shape) -> Bool{ return true}
        
        func fitInCanvas(coord: Coordinate) -> Bool{ return true}
        
        func addShape(shape: Shape) throws {}
        
        func fillBucket(coord: Coordinate, color:Character) throws {}
        
    }
    
    struct MockStrategy: PlotStrategy{
        func buildPlot(coordinates: CoordinatePair) -> [Coordinate]{return []}
    }
}
