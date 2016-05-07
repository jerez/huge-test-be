//
//  Executor.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/6/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/**
 *  Program flow control
 */
struct Executor {
    let buffer = StringBuffer()
    let inputBuilder = InputCreator()
    
    /**
        Run the commands in order
     */
    func doWork(){
        buffer.log("\nInitializing...\n")
        defer{
            flush();
        }
        
        buffer.log("\nLoading file...\n")
        let instructions = loadFromFile()
        guard !instructions.isEmpty else {
            buffer.log("\nNo instructions Found\n")
            return
        }
        
        buffer.log("\nParsing entries...\n")
        let inputs = parseInputs(instructions)
        guard !inputs.isEmpty else {
            buffer.log("\nNo instructions parsed\n")
            return
        }
        
        buffer.log("\nCreating commands...\n")
        let operation = DrawOperation()
        operation.setOutputBuffer(buffer)
        operation.prepareOperation(inputs)
        
        buffer.log("\nPloting...\n")
        let commands = operation.getCommands()
        commands?.execute(operation)
    }
    /**
     Loads the input.txt file
     
     - returns: File content as array of sttrings
     */
    func loadFromFile() -> [String] {
        var instructions:[String] = []
        do{
            instructions = try FileIO().readInput()
        } catch let error as NSError{
            buffer.log("\(error.localizedDescription)")
        }
        return instructions
    }
    
    /**
     Parses the strings loaded into [Input] struct
     
     - parameter instructions: plain instructions
     
     - returns: [Input] array (parsed instructions)
     */
    func parseInputs(instructions:[String]) -> [Input]{
        var inputs:[Input] = []
        for instruction in instructions {
            do {
                inputs.append(try inputBuilder.parseInput(instruction));
            } catch let error as InputParsingError {
                buffer.log("Input Error -> \(error)\n")
            } catch let error {
                buffer.log("\(error)")
            }
        }
        return inputs
    }
    
    /**
     Flushes the program output
     */
    func flush() {
        buffer.toScreen()
        do{
            let fileName = try buffer.toFile();
            print("Output at : \(fileName)")
        } catch let error {
            print(error);
        }
        let charCode = UInt32("1f44d", radix: 16)
        guard charCode != nil else { exit(0) }
        print("\(String(UnicodeScalar(charCode!)))\n")
    }
}
