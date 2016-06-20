//
//  InputTests.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool

class InputTests: XCTestCase {

    override func setUp() { super.setUp() }
    
    override func tearDown() { super.tearDown() }

    func testInputType_equality() {
        let inputTA = InputType.CreateCanvas
        let inputTB = InputType.CreateCanvas
        XCTAssertTrue(inputTA == inputTB)
    }
    
    func testInput_equality_1() {
        let inputTA = InputType.CreateCanvas
        let inputTB = InputType.CreateCanvas
        
        let inputA = Input(type: inputTA, params: [], instruction: "")
        let inputB = Input(type: inputTB, params: [], instruction: "")
        
        XCTAssertTrue(inputA == inputB)
    }
    
    func testInput_equality_2() {
        let inputTA = InputType.CreateCanvas
        let inputA = Input(type: inputTA, params: [], instruction: "")
        let inputB = Input(type: inputTA, params: [""], instruction: "")
        
        XCTAssertFalse(inputA == inputB)
    }
    
    func testInput_equality_3() {
        let inputTA = InputType.CreateCanvas
        let inputA = Input(type: inputTA, params: [1,2,3], instruction: "")
        let inputB = Input(type: inputTA, params: ["1","2","3"], instruction: "")
        
        XCTAssertFalse(inputA == inputB)
    }
    
    func testInput_equality_4() {
        let inputTA = InputType.CreateCanvas
        let inputA = Input(type: inputTA, params: [1,2,3], instruction: "")
        let inputB = Input(type: inputTA, params: [1,2,3], instruction: "")
        
        XCTAssertTrue(inputA == inputB)
    }
    
    func testInput_equality_5() {
        let inputTA = InputType.CreateCanvas
        let inputA = Input(type: inputTA, params: [1,2,3], instruction: "")
        let inputB = Input(type: inputTA, params: [3,2,1], instruction: "")
        
        XCTAssertFalse(inputA == inputB)
    }
    
    func testInputBuilder_creation_Canvas_input() {
        let subject = InputCreator()
        let input = try! subject.parseInput("C 20 4")
        XCTAssertTrue(input.type == InputType.CreateCanvas)
        XCTAssertTrue(input.params[0] as! UInt32 == 20 )
        XCTAssertTrue(input.params[1] as! UInt32 == 4 )
    }

    func testInputBuilder_creation_Line_input() {
        let subject = InputCreator()
        let input = try! subject.parseInput("L 1 2 6 2")
        XCTAssertTrue(input.type == InputType.CreateLine)
        XCTAssertTrue(input.params[0] as! UInt32 == 1 )
        XCTAssertTrue(input.params[1] as! UInt32 == 2 )
        XCTAssertTrue(input.params[2] as! UInt32 == 6 )
        XCTAssertTrue(input.params[3] as! UInt32 == 2 )

    }
    
    func testInputBuilder_creation_Line_input_2() {
        let subject = InputCreator()
        let input = try! subject.parseInput("L 1 1 3 3")
        XCTAssertTrue(input.type == InputType.CreateLine)
        XCTAssertTrue(input.params[0] as! UInt32 == 1 )
        XCTAssertTrue(input.params[1] as! UInt32 == 1 )
        XCTAssertTrue(input.params[2] as! UInt32 == 3 )
        XCTAssertTrue(input.params[3] as! UInt32 == 3 )
        
    }
    
    func testInputBuilder_creation_Rect_input() {
        let subject = InputCreator()
        let input = try! subject.parseInput("R 16 1 20 3")
        XCTAssertTrue(input.type == InputType.CreateRect)
        XCTAssertTrue(input.params[0] as! UInt32 == 16 )
        XCTAssertTrue(input.params[1] as! UInt32 == 1 )
        XCTAssertTrue(input.params[2] as! UInt32 == 20 )
        XCTAssertTrue(input.params[3] as! UInt32 == 3 )
    }
    
    func testInputBuilder_creation_FillB_input() {
        let subject = InputCreator()
        let input = try! subject.parseInput("B 10 3 o")
        XCTAssertTrue(input.type == InputType.BucketFill)
        XCTAssertTrue(input.params[0] as! UInt32 == 10 )
        XCTAssertTrue(input.params[1] as! UInt32 == 3 )
        XCTAssertTrue(input.params[2] as! Character == "o" )
    }
    
    func testInputBuilder_creation_input_throws() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput(""))
    }
    
    func testInputBuilder_creation_input_throws_2() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("lorem ipsum"))
    }
    
    func testInputBuilder_creation_input_throws_3() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("3 3 3 3"))
    }
    
    func testInputBuilder_creation_input_throws_4() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("C3 2 2 2"))
    }
    
    
    func testInputBuilder_creation_Canvas_input_throws() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("C"))
    }
    
    func testInputBuilder_creation_Canvas_input_throws_2() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("C 2"))
    }
    
    func testInputBuilder_creation_Canvas_input_throws_3() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("C 2 c"))
    }
    
    func testInputBuilder_creation_Canvas_input_throws_4() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("C 2 0"))
    }
    
    func testInputBuilder_creation_Rect_input_throws() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_2() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 2"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_3() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 2 2"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_4() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 2 2 2"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_5() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 2 2 2 2"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_6() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 2 1 2 1"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_7() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 1 2 1 2"))
    }
    
    func testInputBuilder_creation_Rect_input_throws_8() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 1 2 0 3"))
    }
    
    func testInputBuilder_creation_Line_input_throws() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("L"))
    }
    
    func testInputBuilder_creation_Line_input_throws_2() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("L 2"))
    }
    
    func testInputBuilder_creation_Line_input_throws_3() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("L 2 2"))
    }
    
    func testInputBuilder_creation_Line_input_throws_4() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("L 2 2 2"))
    }
    
    func testInputBuilder_creation_Line_input_throws_5() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("L 3 4 2 2"))
    }
    
    func testInputBuilder_creation_Line_input_throws_6() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 5 1 2 1"))
    }
    
    func testInputBuilder_creation_Line_input_throws_8() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("R 1 2 0 3"))
    }
    
    
    func testInputBuilder_creation_Fill_input_throws() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B"))
    }
    
    func testInputBuilder_creation_Fill_input_throws_2() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B    "))
    }
    
    func testInputBuilder_creation_Fill_input_throws_3() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B 2"))
    }
    
    func testInputBuilder_creation_Fill_input_throws_4() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B 2 2  "))
    }
    
    func testInputBuilder_creation_Fill_input_throws_5() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B 3 4 2 2"))
    }
    
    func testInputBuilder_creation_Fill_input_throws_6() {
        let subject = InputCreator()
        XCTAssertThrows(try subject.parseInput("B 3 4 vv"))
    }

}



