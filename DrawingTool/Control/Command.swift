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
    internal var _receiver: Drawer?
    
    init(input:Input){
        self._input = input;
    }
    
    func execute(receiver: Drawer)  {
        _receiver = receiver
        _receiver!.logCommand("\(self._input)")
    }
    
    func validateInput(inputType:InputType) -> Bool {
        guard self._input.type == inputType else {
            _receiver?.logCommand("Wrong Input")
            return false }
        guard self._input.params.count == inputType.paramTypes.count else {
            _receiver?.logCommand("Wrong Args")
            return false
        }
        return true
    }
}

// instantiate a Canvas and sends back to receiver
class CreateCanvasCommand: DrawCommand {
    
    override func execute(receiver: Drawer) {
        super.execute(receiver)
        guard super.validateInput(InputType.CreateCanvas) else { return() }
        let canvas = ConcreteCanvas(width: self._input.params[0] as! uint, height: self._input.params[1] as! uint)
        guard canvas != nil else { return }
        receiver.setCanvas(canvas!)
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
        guard InputType.CreateLine == self._input.type || InputType.CreateRect == self._input.type else { return() }
        let coordinateA = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let coordinateB = Coordinate(x: self._input.params[2] as! uint, y: self._input.params[3] as! uint)
        let coordinatePair = (a:coordinateA, b:coordinateB)
        let shape = ConcreteShape(strategy: self._strategy, coordinatePair:coordinatePair, color:  "x")
        receiver.drawInCanvas(shape)
    }
}

/// Create a coordinate struct asn send it to receiver
class BucketFillCommand: DrawCommand {
    
    override func execute(receiver: Drawer)  {
        super.execute(receiver)
        guard super.validateInput(InputType.BucketFill) else { return() }
        let point = Coordinate(x: self._input.params[0] as! uint, y: self._input.params[1] as! uint)
        let color = self._input.params[2] as! Character
        receiver.fillCanvasBucket(point, color: color)
    }
}

