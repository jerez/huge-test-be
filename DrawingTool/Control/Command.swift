//
//  Command.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

protocol Command   {
    func execute(receiver: Drawer)
}


class CommandWrapper: Command {
    private let commands: [Command]
    init(commands: [Command]){
        self.commands = commands
    }
    func execute(receiver: Drawer) {
        commands.forEach{$0.execute(receiver)}
    }
}

class DrawCommand: Command {
    internal var _input: Input
    
    init(input:Input){
        self._input = input;
    }
    
    func execute(receiver: Drawer)  {
        receiver.logCommand("\(self._input)")
    }
}

// instantiate a Canvas and sends back to receiver
class CreateCanvasCommand: DrawCommand {
    
    override func execute(receiver: Drawer) {
        super.execute(receiver)
        let canvas = Canvas(width: self._input.params[0] as! uint, height: self._input.params[1] as! uint)
        receiver.setCanvas(canvas)
    }
}

/// Instantiate a shape with the input provided and send it to receiver
class AddShapeCommand: DrawCommand {
    
    internal var _strategy: PlotStrategy
    init(input:Input, strategy: PlotStrategy){
        self._strategy = strategy
        super.init(input: input)
    }
    
    override func execute(receiver: Drawer)  {
        super.execute(receiver)
        let coordinateA = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let coordinateB = Coordinate(x: self._input.params[2] as! uint, y: self._input.params[3] as! uint)
        let coordinatePair = (a:coordinateA, b:coordinateB)
        let shape = ShapeBuilder(strategy: self._strategy, coordinatePair:coordinatePair, color:  "x")
        receiver.drawInCanvas(shape)
    }
}

/// Create a coordinate struct asn send it to receiver
class BucketFillCommand: DrawCommand {
    
    override func execute(receiver: Drawer)  {
        super.execute(receiver)
        let point = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let color = self._input.params[2] as! Character
        receiver.fillCanvasBucket(point, color: color)
    }
}

