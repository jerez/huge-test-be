//
//  Drawer.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


protocol Drawer{
    var canvas: Canvas? { get }
    func setCanvas(canvas:Canvas)
}


class DrawOperation: Drawer {
    
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
                let input = try self._builder.parseInput(string);
                OutputBuffer.sharedInstance.log("Loaded command -> \(input)")
                addCommand(DrawOperation.notify, content: input.type.description )
                
                switch input.type {
                case .CreateCanvas:
                    addCommand(DrawOperation.notify, content: "ploting -> \(input)")
                    self._commands.append(CreateCanvasCommand(input:input))
                    
                case .CreateLine:
                    addCommand(DrawOperation.notify, content: "ploting -> \(input)")
                    self._commands.append(AddShapeCommand(input:input, strategy: lineStrategy))
                    
                case .CreateRect:
                    addCommand(DrawOperation.notify, content: "ploting -> \(input)")
                    self._commands.append(AddShapeCommand(input:input, strategy: rectStrategy))
                    
                case .BucketFill:
                    addCommand(DrawOperation.notify, content: "ploting -> \(input)")
                    self._commands.append(BucketFillCommand(input:input))
                }
            }
        }
    }
    
    func notify(message: String){
       OutputBuffer.sharedInstance.log(message)
    }
    
    private func addCommand(action: DrawOperation -> String -> (), content: String){
        dispatch_sync(_queue) { () -> () in
            self._commands.append(GenericCommand.createCommand({ prep  in
                action(prep)(content)
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