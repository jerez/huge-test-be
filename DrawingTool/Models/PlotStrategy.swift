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

class LineStrategy : PlotStrategy {
    func buildPlot(coordinates: CoordinatePair) -> [Coordinate]{
        
        let transCoords = transformCoordinates(coordinates)
        
        var plot = [Coordinate]()
        
        for x in transCoords.origin.x...transCoords.end.x {
            for y in transCoords.origin.y...transCoords.end.y {
                plot.append(Coordinate(x: x, y: y))
            }
        }
        return plot;
    }
    
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

class RectStrategy : LineStrategy {
    
    override func buildPlot(coordinates: CoordinatePair) -> [Coordinate]{
        var plot = [Coordinate]()
        let coordArray = [
            (Coordinate(x: coordinates.a.x, y: coordinates.a.y), Coordinate(x: coordinates.b.x, y: coordinates.a.y)),
            (Coordinate(x: coordinates.b.x, y: coordinates.a.y), Coordinate(x: coordinates.b.x, y: coordinates.b.y)),
            (Coordinate(x: coordinates.b.x, y: coordinates.b.y), Coordinate(x: coordinates.a.x, y: coordinates.b.y)),
            (Coordinate(x: coordinates.a.x, y: coordinates.b.y), Coordinate(x: coordinates.a.x, y: coordinates.a.y)),
            ]
        for coordPair in coordArray {
            let linePlot = super.buildPlot(coordPair);
            plot.appendContentsOf(linePlot)
        }
        return plot
    }
}