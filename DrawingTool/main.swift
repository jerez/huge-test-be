//
//  main.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


protocol Plotter{
    var canvas: Canvas? { get }
    func setCanvas(canvas:Canvas)
}


class PlotOperation: Plotter {
    
    var canvas: Canvas? {
        get { return self._canvas }
    }
    func setCanvas(canvas:Canvas){self._canvas=canvas}

    private var _canvas: Canvas?
    private let _builder: InputBuilder
    private let _stringInstructions: [String]
    private var _queue = dispatch_queue_create("commandQueue", DISPATCH_QUEUE_SERIAL)
    private var _inputs: [Input] = []
    private var _commands: [Command] = []
    
    
    init(inputBuilder: InputBuilder, stringInstructions: [String]) {
        self._builder = inputBuilder
        self._stringInstructions = stringInstructions;
        self._inputs = [Input]()
    }
    
    func prepareOperation() throws {
        let lineStrategy = LineStrategy()
        let rectStrategy = RectStrategy()
        
        for string in self._stringInstructions {
            if !string.isEmpty{
                do {
                    let input = try self._builder.parseInput(string);
                    print("Loaded command -> \(input)")
                    addCommand(PlotOperation.notify, message: input.type.description )
                    
                    switch input.type {
                    case .CreateCanvas:
                        addCommand(PlotOperation.notify, message: "ploting -> \(input)")
                        self._commands.append(CreateCanvasCommand(input:input))
    
                    case .CreateLine:
                        addCommand(PlotOperation.notify, message: "ploting -> \(input)")
                        self._commands.append(AddShapeCommand(input:input, strategy: lineStrategy))

                    case .CreateRect:
                        addCommand(PlotOperation.notify, message: "ploting -> \(input)")
                        self._commands.append(AddShapeCommand(input:input, strategy: rectStrategy))
                        
                    case .BucketFill:
                        addCommand(PlotOperation.notify, message: "ploting -> \(input)")
                        self._commands.append(BucketFillCommand(input:input))
                    }
  
                } catch let error as InputParsingError {
                    print("Error -> \(error.description)")
                } catch let error {
                    print("Something unexpected went wrong! :( ")
                    throw error
                }
            }
        }
    }
    func notify(input: String){
        print(input)
    }
    
    private func addCommand(action: PlotOperation -> String -> (), message: String){
        dispatch_sync(_queue) { () -> () in
            self._commands.append(GenericCommand.createCommand({ prep  in
                action(prep)(message)
            }))
        }
    }
    func getCommand() -> protocol <Command>? {
        var command: protocol <Command>?
        dispatch_sync(self._queue) {
            () -> () in
            command = CommandWrapper(commands: self._commands)
        }
        return command
    }
}


let string_commands = [
    "C 50 4",
    "L 1 2 6 2",
    "L 6 3 6 4",
    "R 16 1 20 3",
    "R 26 1 44 4",
    "B 10 3 o",
]


//TODO :: extract builder as a stand alone class
let inputBuilder = Input(type: InputType.CreateCanvas(""), params:[Any]())
let operation = PlotOperation(inputBuilder:inputBuilder, stringInstructions: string_commands)

try operation.prepareOperation()
print("Ploting...")
let commands = operation.getCommand()
commands?.execute(operation)
print("\n")


