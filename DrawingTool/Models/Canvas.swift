//
//  Canvas.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


enum CanvasDrawingError: ErrorType {
    case ShapeDoesntFits(String, String)
    case CanvasDoesntExists
}

class Canvas {
    
    private static let EMPTY_COLOR : Character = " "
    private static let HRZ_LINE_COLOR : Character = "-"
    private static let VRT_LINE_COLOR : Character = "|"
    private let _width, _height: uint
    private var _plotMatrix: [[Character]]?;
    
    init(width: uint, height: uint) {
        self._width = width
        self._height = height
        self._plotMatrix = Canvas.initMatrix(width, height:height);
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
    
    func addShape(shape: Shape) throws {
        guard self.shapeFits(shape) else { throw CanvasDrawingError.ShapeDoesntFits("\(shape.coordinates)", self.description) }
        self.plotShape(shape);
    }
    
    func fillBucket(coord: Coordinate, color:Character){
        let currentColor = self._plotMatrix![Int(coord.y)][Int(coord.x)]
        self.fillBucketRecursive(coord, fillColor: color, initialcolor: currentColor)
    }
    
    private func fillBucketRecursive(coord: Coordinate, fillColor:Character, initialcolor:Character){
        if self.fitInCanvas(coord) && self.canFillPoint(coord, color: initialcolor) {
            self.plotPoint(coord, color: fillColor)
            let neighbors = [
                Coordinate(x: coord.x+1, y: coord.y),
                Coordinate(x: coord.x-1, y: coord.y),
                Coordinate(x: coord.x, y:coord.y+1),
                Coordinate(x: coord.x, y:coord.y-1),
                ]
            for neighbor in neighbors {
                fillBucketRecursive(neighbor, fillColor: fillColor, initialcolor: initialcolor)
            }
        }
    }
    
    private func fitInCanvas(coord: Coordinate) -> Bool {
        let greaterThanZero = (coord.x > 0 && coord.y > 0)
        let lesserThanSize = (coord.x <= self._width && coord.y <= self._height)
        return  greaterThanZero && lesserThanSize
    }
    
    private func plotShape(shape: Shape){
        let color = shape.color
        let shapePlot = shape.plot
        for coord in shapePlot! {
            self.plotPoint(coord, color: color)
        }
    }
    
    private func plotPoint(coord: Coordinate, color:Character){
        self._plotMatrix! [Int(coord.y)][Int(coord.x)] = color
    }
    
    private func canFillPoint(coord: Coordinate, color:Character) -> Bool {
        let currentColor = self._plotMatrix![Int(coord.y)][Int(coord.x)]
        return currentColor == color
    }
    
    private static func initMatrix(width: uint, height: uint) -> [[Character]]{
        let plotWidth = Int(width + 2)
        let plotHeight = Int(height + 1)
        
        let horizontalLine = (Array(count:plotWidth, repeatedValue: Canvas.HRZ_LINE_COLOR))
        var emptyLine = Array(count:Int(width), repeatedValue: Canvas.EMPTY_COLOR)
        emptyLine.insert(Canvas.VRT_LINE_COLOR, atIndex: 0)
        emptyLine.insert(Canvas.VRT_LINE_COLOR, atIndex: Int(width)+1)
        
        var plotMatrix = [[Character]]()
        for rowNum in 0...plotHeight {
            let isBorder = rowNum == 0 || rowNum == plotHeight
            plotMatrix.append(isBorder ? horizontalLine : emptyLine)
        }
        return plotMatrix
    }
}



