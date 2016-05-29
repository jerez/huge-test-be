//
//  PlotStrategy.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

protocol PlotStrategy {
    func buildPlot(coordinates: CoordinatePair) -> [Coordinate]
}

/// Algorithm to plot Lines
class LineStrategy : PlotStrategy {
    func buildPlot(coordinates: CoordinatePair) -> [Coordinate]{
        
        guard greaterThanZero(coordinates) && isLine(coordinates) else {
            return []
        }
        
        let transCoords = transformCoordinates(coordinates)
        var plot = [Coordinate]()
        
        for x in transCoords.origin.x...transCoords.end.x {
            for y in transCoords.origin.y...transCoords.end.y {
                plot.append(Coordinate(x: x, y: y))
            }
        }
        return plot;
    }
    private func greaterThanZero(coordinates: CoordinatePair) -> Bool {
        return coordinates.a.x > 0 && coordinates.b.x > 0 && coordinates.a.y > 0 && coordinates.b.y > 0
    }
    private func isLine(coordinates: CoordinatePair) -> Bool {
        return coordinates.a.x == coordinates.b.x || coordinates.a.y == coordinates.b.y
    }
    
    
    /**
     Transforms coordinates to be ploted from init to end (init is the most closer to 0,0)
     
     - parameter coords: Pair of coordinates
     
     - returns: Pair of ordered coordinates
     */
    private func transformCoordinates(coords: CoordinatePair)->(origin: Coordinate, end: Coordinate){
        return (
            origin: Coordinate(
                x: min(coords.a.x, coords.b.x),
                y: min(coords.a.y, coords.b.y)
            ),
            end:  Coordinate(
                x: max(coords.a.x, coords.b.x),
                y: max(coords.a.y, coords.b.y)
            ))
    }
}

/// Algorithm to plot Rects
class RectStrategy : LineStrategy {
    
    override func buildPlot(coordinates: CoordinatePair) -> [Coordinate] {
        guard greaterThanZero(coordinates) && !isLine(coordinates)  else { return [] }

        let transCoords = transformCoordinates(coordinates)

        var plot = [Coordinate]()
        [   (Coordinate(x: transCoords.origin.x, y: transCoords.origin.y), Coordinate(x: transCoords.end.x, y: transCoords.origin.y)),
            (Coordinate(x: transCoords.end.x, y: transCoords.origin.y+1 ), Coordinate(x: transCoords.end.x, y: transCoords.end.y)),
            (Coordinate(x: transCoords.end.x-1, y: transCoords.end.y), Coordinate(x: transCoords.origin.x, y: transCoords.end.y)),
            (Coordinate(x: transCoords.origin.x, y: transCoords.end.y-1), Coordinate(x: transCoords.origin.x , y: transCoords.origin.y+1)),
            ].forEach{
                    let linePlot = super.buildPlot($0);
                    plot.appendContentsOf(linePlot)
        }
        return plot
    }
}

class DiagonalStrategy : LineStrategy {
    override func buildPlot(coordinates: CoordinatePair) -> [Coordinate] {
        guard greaterThanZero(coordinates) && isDiagonalLine(coordinates) else {
            return []
        }
        
        let plotSize = abs(Int(coordinates.a.x) - Int(coordinates.b.x))
        let isXIncrement = coordinates.a.x < coordinates.b.x
        let isYIncrement = coordinates.a.y < coordinates.b.y
        
        var plot = [Coordinate]()
        
        for i in 0...plotSize {
            let xValue = isXIncrement ? coordinates.a.x + uint(i) : coordinates.a.x - uint(i)
            let yValue = isYIncrement ? coordinates.a.y + uint(i) : coordinates.a.y - uint(i)
            plot.append(Coordinate(x: xValue, y: yValue))
        }
        return plot;
    }
    
    private func isDiagonalLine(coordinates: CoordinatePair) -> Bool {
        return abs(Int(coordinates.b.x) - Int(coordinates.a.x)) == abs(Int(coordinates.b.y) - Int(coordinates.a.y))
    }
}

