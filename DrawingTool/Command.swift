//
//  Command.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

protocol Command {
    func execute(receiver: Plotter)
}

class GenericCommand<T>: Command {
    private var instruction: T -> ()
    init(instruction: T -> ()){
        self.instruction = instruction
    }
    func execute(receiver: Plotter) {
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
    func execute(receiver: Plotter) {
        commands.forEach{$0.execute(receiver)}
    }
}

struct CreateCanvasCommand: Command {
    var input: Input
    
    func execute(receiver: Plotter) {
        let canvas = Canvas(width: input.params[0] as! uint, height: input.params[1] as! uint)
        receiver.setCanvas(canvas)
        for row in canvas.plot {
            print (String(row));
        }
        return ()
    }
}

struct AddShapeCommand: Command {
    var input: Input
    var strategy: PlotStrategy;
    
    func execute(receiver: Plotter) {
        let coordinateA = Coordinate(x: input.params[0] as! uint, y:input.params[1] as! uint)
        let coordinateB = Coordinate(x: input.params[2] as! uint, y:input.params[3] as! uint)
        let coordinatePair = (a:coordinateA, b:coordinateB)
        let line = ShapeBuilder(strategy: strategy, coordinatePair:coordinatePair, color:  "x")
        do {
            try receiver.canvas?.addShape(line)
        } catch let error as CanvasDrawingError {
            print("Error, IGNORING COMMAND!!! -> \(error.description)")
        } catch _ {
            print("Something unexpected went wrong when drawing a shape! :( ")
        }
        for row in receiver.canvas!.plot {
            print (String(row));
        }
        return ()
    }
}

struct BucketFillCommand: Command {
    var input: Input
    
    func execute(receiver: Plotter) {
        let point = Coordinate(x: input.params[0] as! uint, y:input.params[1] as! uint)
        let color = input.params[2] as! Character
        receiver.canvas?.fillBucket(point, color: color)
        for row in receiver.canvas!.plot {
            print (String(row));
        }
        return ()
    }
}

