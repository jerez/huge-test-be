//
//  Canvas.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


enum CanvasDrawingError: ErrorType {
    case PointNotInCanvas(String)
    case ShapeDoesntFits(String, String)
    case CanvasDoesntExists
    case InvalidShape

}

protocol Canvas{
    /**
     Canvas initializer, main plot section to draw Shapes
     
     - parameter width:  inner section width (without borders)
     - parameter height: inner section height (without borders)
     
     - returns: Canvas instance or nil if width and height are not valid
     */
    init?(width: uint, height: uint)
    var width: uint { get }
    var height: uint{ get }
    var plot: [[Character]] { get }
    /**
     helper method used to determine if a shape fits into current canvas
     
     - parameter shape: shape instance to be evaluated
     
     - returns: True if fits
     */
    func shapeFits(shape: Shape) -> Bool
    
    /**
     Helper methos used to determine if a point is inside canvas
     
     - parameter coord: point to be evaluated
     
     - returns: True if point is inside
     */
    func fitInCanvas(coord: Coordinate) -> Bool
    
    /**
     Adds a shape plot(coordinate array) into canvas plot to be drawn later
     
     - parameter shape: shape to be addded
     
     - throws: can throw an CanvasDrawingError.ShapeDoesntFits Error if shape does not fit into canvas
     */
    func addShape(shape: Shape) throws
    
    /**
     Fills bucket starting at the coord position
     
     - parameter coord: initial point of fill
     - parameter color: character used to fill
     
     - throws: can throw an CanvasDrawingError.PointNotInCanvas Error if point is outside canvas
     */
    func fillBucket(coord: Coordinate, color:Character) throws
}

class ConcreteCanvas: Canvas {
    
    private static let EMPTY_COLOR : Character = " "
    private static let HRZ_LINE_COLOR : Character = "-"
    private static let VRT_LINE_COLOR : Character = "|"
    private let _width, _height: uint
    private var _plotMatrix: [[Character]]?;

    required init?(width: uint, height: uint) {
        guard (width, height) > (0, 0) else {return nil }
        self._width = width
        self._height = height
        self._plotMatrix = ConcreteCanvas.initMatrix(width, height:height);
    }
    
    var width: uint {
        get { return self._width}
    }
    
    var height: uint{
        get { return self._height }
    }
    
    var plot: [[Character]] {
        get { return self._plotMatrix! }
    }
    
    func shapeFits(shape: Shape) -> Bool {
        return self.fitInCanvas(shape.coordinates.a) && self.fitInCanvas(shape.coordinates.b)
    }
    
    func fitInCanvas(coord: Coordinate) -> Bool {
        let greaterThanZero = (coord.x > 0 && coord.y > 0)
        let lesserThanSize = (coord.x <= self._width && coord.y <= self._height)
        return  greaterThanZero && lesserThanSize
    }
    
    func addShape(shape: Shape) throws {
        guard self.shapeFits(shape) else { throw CanvasDrawingError.ShapeDoesntFits("\(shape.coordinates)", self.description) }
        self.plotShape(shape);
    }
    
    func fillBucket(coord: Coordinate, color:Character) throws {
        guard self.fitInCanvas(coord) else { throw CanvasDrawingError.PointNotInCanvas("\(coord)") }
        let currentColor = self._plotMatrix![Int(coord.y)][Int(coord.x)]
        self.fillBucketRecursive(coord, fillColor: color, initialcolor: currentColor)
    }
    
    private func fillBucketRecursive(coord: Coordinate, fillColor:Character, initialcolor:Character){
        if self.fitInCanvas(coord) && self.canFillPoint(coord, color: initialcolor) {
            self.plotPoint(coord, color: fillColor)
            [   Coordinate(x: coord.x+1, y: coord.y),Coordinate(x: coord.x-1, y: coord.y),
                Coordinate(x: coord.x, y:coord.y+1),
                Coordinate(x: coord.x, y:coord.y-1)
                ].forEach{
                    fillBucketRecursive($0, fillColor: fillColor, initialcolor: initialcolor)
            }
        }
    }
    
    private func plotShape(shape: Shape){
        let color = shape.color
        let shapePlot = shape.plot
        shapePlot!.forEach{ self.plotPoint($0, color: color) }
    }
    
    private func plotPoint(coord: Coordinate, color:Character){
        self._plotMatrix! [Int(coord.y)][Int(coord.x)] = color
    }
    
    private func canFillPoint(coord: Coordinate, color:Character) -> Bool {
        let currentColor = self._plotMatrix![Int(coord.y)][Int(coord.x)]
        return currentColor == color
    }
    
    /**
     Initializes internal plot matrix
     
     - parameter width:  canvas width
     - parameter height: canvas height
     
     - returns: Matrix of [height + 2 ][ width + 2 ] prefilled with empty spaces and borders
     */
    private static func initMatrix(width: uint, height: uint) -> [[Character]]{
        let plotWidth = Int(width + 2)
        let plotHeight = Int(height + 1)
        
        let horizontalLine = (Array(count:plotWidth, repeatedValue: ConcreteCanvas.HRZ_LINE_COLOR))
        var emptyLine = Array(count:Int(width), repeatedValue: ConcreteCanvas.EMPTY_COLOR)
        emptyLine.insert(ConcreteCanvas.VRT_LINE_COLOR, atIndex: 0)
        emptyLine.insert(ConcreteCanvas.VRT_LINE_COLOR, atIndex: Int(width)+1)
        
        var plotMatrix = [[Character]]()
        for rowNum in 0...plotHeight {
            let isBorder = rowNum == 0 || rowNum == plotHeight
            plotMatrix.append(isBorder ? horizontalLine : emptyLine)
        }
        return plotMatrix
    }
}



