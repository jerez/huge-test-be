//
//  main.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


let string_commands = [
    "C 40 8",
    "L 1 4 12 4",
    "L 12 4 12 8",
    "R 32 2 40 6",
    "B 20 6 o",
]


let inputBuilder = InputCreator()
let operation = PlotOperation(inputBuilder:inputBuilder, stringInstructions: string_commands)
do {
    do {
        try operation.prepareOperation()
    } catch let error as InputParsingError {
        print("Error -> \(error.description)")
    }
    do {
        print("Ploting...")
        let commands = operation.getCommand()
        try commands?.execute(operation)
    } catch let error as CanvasDrawingError {
        print("WARN IGNORING COMMAND!!! \(error.description)")
    }
}
catch _ {
    print("Something unexpected went wrong! :( ")
}

print("\n")


