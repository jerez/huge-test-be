//
//  Coordinate.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

struct Coordinate {
    let x: uint
    let y: uint
}

extension Coordinate: Equatable {}

// MARK: Equatable

func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    // Naive equality that uses number comparison rather than resolving equivalent selectors
    return lhs.x == rhs.x && lhs.y == rhs.y
}

typealias CoordinatePair = (a: Coordinate, b: Coordinate)


