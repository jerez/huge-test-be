//
//  Shape.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/**
 *  Represents any drawable object to be putted inside canvas plot
 */
protocol Shape {
    var color: Character { get set }
    var coordinates: CoordinatePair { get }
    var plot:[Coordinate]? { get }
}

/**
 *  Concrete implementation of shape that uses 
 *  a strategy to determine if should build a line or a rect
 */
class ShapeBuilder: Shape {
    
    internal let _strategy: PlotStrategy;
    internal let _coordPair: CoordinatePair;
    internal var _plot:[Coordinate]?
    
    var color: Character
    var coordinates: CoordinatePair { get { return self._coordPair } }

    /**
     Shape Builder initializer
     
     - parameter strategy:       LineStrategy or RectStrategy
     - parameter coordinatePair: Coordinates that defines start an end of shape
     - parameter color:          character used to plot
     
     - returns: Builds a shape plot (Array of coordinates)
     */
    init(strategy:PlotStrategy, coordinatePair: CoordinatePair, color: Character){
        self._strategy = strategy
        self._coordPair = coordinatePair
        self.color = color
    }
    
    var plot: [Coordinate]? {
         get {
            if self._plot == nil {
                self._plot = self._strategy.buildPlot(_coordPair)
            }
            return self._plot
        }
    }
}

