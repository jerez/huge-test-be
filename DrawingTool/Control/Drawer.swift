//
//  Drawer.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/**
 *  Defines the interface needed for an operation implementation
 */
protocol Operation {
    /**
     Build commands and queue those to be executed later
     */
    func prepareOperation(instructions: Array<Input>)
    
    /**
     Return Commands serially
    */
    func getCommands() -> protocol <Command>?
}

/**
 *  Defines the interface needed for a drawer implementation
 */
protocol Drawer{
    /**
     Logs string into buffer
     
     - parameter entry: log entry
     */
    func logCommand(entry: String)
    /**
     Sets buffer implementation to a drawer instance
     
     - parameter buffer: Object used to store outputs
     */
    func setOutputBuffer(buffer: OutputBuffer)
    
    /**
     Actual canvas to be drawn
     
     - parameter canvas: Instance of Canvas
     */
    func setCanvas(canvas: Canvas)
    /**
     Convenience method to draw shape into its canvas
     
     - parameter shape: Shape instance
     */
    func drawInCanvas(shape: Shape)
    /**
     Convenience method to fill bucket of its canvas
     
     - parameter point: Coordinate of point
     - parameter color: Character to be drawn
     
     */
    func fillCanvasBucket(point: Coordinate, color:Character)
}

/// Actual implementation od Drawer Operation
class DrawOperation {
    private var _commands: [Command] = []
    private var _queue = dispatch_queue_create("commandQueue", DISPATCH_QUEUE_SERIAL)
    private var _canvas: Canvas?
    private var _buffer: OutputBuffer?
}


// MARK: - Drawer
extension DrawOperation: Drawer {
    func setOutputBuffer(buffer: OutputBuffer) {
        self._buffer = buffer
    }
    
    func setCanvas(canvas:Canvas){
        self._canvas = canvas
        self._buffer?.appendToBuffer(self.getCanvasContent())
    }
    
    func drawInCanvas(shape:Shape) {
        do{
            guard self._canvas != nil else { throw CanvasDrawingError.CanvasDoesntExists }
            try self._canvas!.addShape(shape)
            self._buffer?.appendToBuffer(self.getCanvasContent())
        } catch let error {
            self._buffer?.log("\(error)")
        }
    }
    func fillCanvasBucket(point: Coordinate, color:Character) {
        do{
            guard self._canvas != nil else { throw CanvasDrawingError.CanvasDoesntExists }
            try!  self._canvas!.fillBucket(point, color: color)
            self._buffer?.appendToBuffer(self.getCanvasContent())
        } catch let error {
            self._buffer?.log("\(error)")
        }
    }
    
    private func getCanvasContent()-> String {
        let contentArray = self._canvas!.plot.map{String($0)}
        return contentArray.joinWithSeparator("\n")
    }
}

// MARK: - Operation
extension DrawOperation : Operation{
    
    func logCommand(entry: String) {
        self._buffer?.log(entry)
    }
    
    func prepareOperation(instructions: [Input]) {
        let lineStrategy = LineStrategy()
        let rectStrategy = RectStrategy()
        for input in instructions {
            self._buffer?.log(input.description)
            switch input.type {
            case .CreateCanvas:
                self._commands.append(CreateCanvasCommand(input:input))
            case .CreateLine:
                self._commands.append(AddShapeCommand(input:input, strategy: lineStrategy))
            case .CreateRect:
                self._commands.append(AddShapeCommand(input:input, strategy: rectStrategy))
            case .BucketFill:
                self._commands.append(BucketFillCommand(input:input))
            }
        }
    }
    
    func getCommands() -> protocol <Command>?{
        var command: protocol <Command>?
        dispatch_sync(self._queue) {
            () -> () in
            command = CommandWrapper(commands: self._commands)
        }
        return command
    }
    
}


