//
//  Shape.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

protocol Shape {
    var color: Character { get set }
    var coordinates: CoordinatePair { get }
    var plot:[Coordinate]? { get }
}


class ShapeBuilder: Shape {
    
    internal let _strategy: PlotStrategy;
    internal let _coordPair: CoordinatePair;
    internal var _plot:[Coordinate]?
    
    var color: Character
    var coordinates: CoordinatePair { get { return self._coordPair } }

    
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

