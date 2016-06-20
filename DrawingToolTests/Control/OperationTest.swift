//
//  OperationTest.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/29/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import XCTest
@testable import DrawingTool

class OperationTest: XCTestCase {

    override func setUp() { super.setUp() }
    
    override func tearDown() { super.tearDown() }

    func testStrategyInjection() {
        let subject: Operation = DrawOperation();
        let input = Input(type: InputType.CreateLine, params: [1,1,4,1], instruction: "")
        subject.prepareOperation([input])
        let command = subject.getCommands()
       command.
        
    }


}
