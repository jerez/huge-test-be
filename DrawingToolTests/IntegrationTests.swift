//
//  IntegrationTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool

class IntegrationTests: XCTestCase {

    let string_commands = [
        "C 20 4",
        "L 1 2 6 2",
        "L 6 3 6 4",
        "R 16 1 20 3",
        "B 10 3 o",
        ]
    
    var inputBuilder: InputBuilder?

    
    override func setUp() {
        super.setUp()
        inputBuilder = InputCreator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanvasCreation() {
        let operation = PlotOperation(inputBuilder:self.inputBuilder!, stringInstructions: Array(arrayLiteral: string_commands.first!))
        try! operation.prepareOperation()
        try! operation.getCommand()?.execute(operation)
        
        XCTAssertEqual(operation.canvas?.width, 20)
        XCTAssertEqual(operation.canvas?.height, 4)
        XCTAssertEqual(operation.canvas?.plot.flatMap{$0}.count, (4+2)*(20+2) )
    }
    
    func testLineCreation() {
        let commands =  [string_commands[0], string_commands[1]]
        let operation = PlotOperation(inputBuilder:self.inputBuilder!, stringInstructions: commands)
        try! operation.prepareOperation()
        try! operation.getCommand()?.execute(operation)
        
        XCTAssertEqual(operation.canvas?.plot[2][1], "x")
        XCTAssertEqual(operation.canvas?.plot[2][2], "x")
        XCTAssertEqual(operation.canvas?.plot[2][3], "x")
        XCTAssertEqual(operation.canvas?.plot[2][4], "x")
        XCTAssertEqual(operation.canvas?.plot[2][5], "x")
        XCTAssertEqual(operation.canvas?.plot[2][6], "x")

    }
    
    func testPrepareOperationPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            let operation = PlotOperation(inputBuilder:self.inputBuilder!, stringInstructions: self.string_commands)
            try! operation.prepareOperation()
        }
    }
    
    func testWholeOperationPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            let operation = PlotOperation(inputBuilder:self.inputBuilder!, stringInstructions: self.string_commands)
            try! operation.prepareOperation()
            try! operation.getCommand()?.execute(operation)
        }
    }

}
