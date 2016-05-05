//
//  Command.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

protocol Command   {
    func execute(receiver: Drawer) throws
}

class GenericCommand<T>: Command {
    private var instruction: T -> ()
    init(instruction: T -> ()){
        self.instruction = instruction
    }
    func execute(receiver: Drawer) throws {
        guard let safeReceiver = receiver as? T else {
            fatalError("Receiver is not an expected type")
        }
        return instruction(safeReceiver)
    }
    class func createCommand(instruction: T -> ()) -> Command {
        return GenericCommand(instruction: instruction)
    }
}

class CommandWrapper: Command {
    private let commands: [Command]
    init(commands: [Command]){
        self.commands = commands
    }
    func execute(receiver: Drawer) throws {
        try commands.forEach{ try $0.execute(receiver)}
    }
}

class DrawCommand: Command {
    
    internal var _input: Input
    init(input:Input){
        self._input = input;
    }
    
    func execute(receiver: Drawer) throws {
        guard receiver.canvas != nil else { return }
        
        var canvasContent:[String] = []
        for row in receiver.canvas!.plot {
            canvasContent.append(String(row));
        }
        OutputBuffer.sharedInstance.append(canvasContent)
    }
}

class CreateCanvasCommand: DrawCommand {
    
    override func execute(receiver: Drawer) throws {
        let canvas = Canvas(width: self._input.params[0] as! uint, height: self._input.params[1] as! uint)
        receiver.setCanvas(canvas)
        try super.execute(receiver)
    }
}

class AddShapeCommand: DrawCommand {
    
    internal var _strategy: PlotStrategy
    init(input:Input, strategy: PlotStrategy){
        self._strategy = strategy
        super.init(input: input)
    }
    
    override func execute(receiver: Drawer) throws {
        let coordinateA = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let coordinateB = Coordinate(x: self._input.params[2] as! uint, y: self._input.params[3] as! uint)
        let coordinatePair = (a:coordinateA, b:coordinateB)
        let line = ShapeBuilder(strategy: self._strategy, coordinatePair:coordinatePair, color:  "x")
        guard receiver.canvas != nil else { return }
        guard receiver.canvas!.shapeFits(line) else { return }
        
        try receiver.canvas!.addShape(line)
        try super.execute(receiver)
    }
}

class BucketFillCommand: DrawCommand {
    
    override func execute(receiver: Drawer) throws {
        let point = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let color = self._input.params[2] as! Character
        guard receiver.canvas != nil else { return }
        guard receiver.canvas!.fitInCanvas(point) else { return }
        
        try receiver.canvas!.fillBucket(point, color: color)
        try super.execute(receiver)
    }
}

