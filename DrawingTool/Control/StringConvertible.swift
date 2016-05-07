//
//  StringConvertible.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/6/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


extension ConcreteCanvas: CustomStringConvertible{
    var description: String{
        return "Canvas -> {width:\(self.width) height:\(self.height)}"
    }
}

extension CanvasDrawingError: CustomStringConvertible {
    var description: String {
        switch self {
        case .PointNotInCanvas(let coord): return "Point :{\"\(coord)\"} is outside canvas)"
        case ShapeDoesntFits(let coords, let canvas): return "Shape :{\"\(coords)\"} doesn't fits in canvas : \(canvas)"
        case CanvasDoesntExists: return "Canvas doesn't exists"
        case InvalidShape: return "Invalid Shape"
        }
    }
}

extension Input: CustomStringConvertible {
    var description: String {
        return "Input(\(self.type.description))"
    }
}

extension InputType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case CreateCanvas(let inputString):  return "CreateCanvas -> {\"\(inputString)\"}"
        case CreateLine(let inputString): return "CreateLine -> {\"\(inputString)\"}"
        case CreateRect(let inputString): return "CreateRect -> {\"\(inputString)\"}"
        case BucketFill(let inputString): return "BucketFill -> {\"\(inputString)\"}"
        }
    }
}

extension InputParsingError: CustomStringConvertible {
    var description: String {
        switch self {
        case WrongInput(let input): return "Error parsing {\"\(input)\"} as a valid input"
        case WrongArgumentNumber(let input, let expect, let got):
            return "Wrong arguments number, expected {\(expect)} got {\(got)} in \(input)"
        case WrongArgumentValue(let input, let val):  return "Wrong argument value {\(val)} in \(input)"
        }
    }
}


