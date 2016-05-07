//
//  IntegrationTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/6/16.
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
    var operation: DrawOperation?
    let inputBuilder = InputCreator()

    
    override func setUp() {
        super.setUp()
        operation = DrawOperation()
    }
    
    func testCanvasCreation() {
        let input = try! inputBuilder.parseInput(string_commands.first!)
        operation!.prepareOperation([input])
        operation!.getCommands()?.execute(operation!)
        
        XCTAssertEqual(operation!.canvas?.width, 20)
        XCTAssertEqual(operation!.canvas?.height, 4)
        XCTAssertEqual(operation!.canvas?.plot.flatMap{$0}.count, (4+2)*(20+2) )
    }
    
    func testLineCreation() {
        let instructions =  [string_commands[0], string_commands[1]]
        let commands = instructions.map{ try! inputBuilder.parseInput($0) }

        operation!.prepareOperation(commands)
        operation!.getCommands()?.execute(operation!)
        
        XCTAssertEqual(operation!.canvas?.plot[2][1], "x")
        XCTAssertEqual(operation!.canvas?.plot[2][2], "x")
        XCTAssertEqual(operation!.canvas?.plot[2][3], "x")
        XCTAssertEqual(operation!.canvas?.plot[2][4], "x")
        XCTAssertEqual(operation!.canvas?.plot[2][5], "x")
        XCTAssertEqual(operation!.canvas?.plot[2][6], "x")

    }
    
    func testPrepareOperationPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            let commands = self.string_commands.map{ try! self.inputBuilder.parseInput($0) }
            self.operation!.prepareOperation(commands)
        }
    }
    
    func testWholeOperationPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            let commands = self.string_commands.map{ try! self.inputBuilder.parseInput($0) }
            self.operation!.prepareOperation(commands)
            self.operation!.getCommands()?.execute(self.operation!)
        }
    }

}
