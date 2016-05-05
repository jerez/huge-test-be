//
//  Input.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

struct Input {
    let type: InputType
    let params:[Any]
}

enum InputType {
    
    case CreateCanvas(String)
    case CreateLine(String)
    case CreateRect(String)
    case BucketFill(String)
    
    enum ParamType {
        case String
        case Number
    }
    var paramTypes: [ParamType]{
        switch self {
        case CreateCanvas: return [.Number, .Number]
        case CreateLine, CreateRect: return [.Number, .Number, .Number, .Number]
        case BucketFill: return [.Number, .Number, .String]
        }
    }
    
}

extension InputType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case CreateCanvas(let inputString):  return "InputType :: CreateCanvas -> {\"\(inputString)\"}"
        case CreateLine(let inputString): return "InputType :: CreateLine -> {\"\(inputString)\"}"
        case CreateRect(let inputString): return "InputType :: CreateRect -> {\"\(inputString)\"}"
        case BucketFill(let inputString): return "InputType :: BucketFill -> {\"\(inputString)\"}"
        }
    }
}

enum InputParsingError: ErrorType {
    case WrongInput(String)
    case WrongArgumentNumber(String, Int, Int)
    case WrongArgumentValue(String, String)
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


protocol InputBuilder {
    func parseInput (string: String) throws -> Input
    func parseArgs (inputType: InputType, args: [String]) throws -> [Any]
}

extension Input: InputBuilder {
    func parseInput(string: String) throws -> Input{
        let stripped = self.stripSpaces(string)
        let splitted = stripped.componentsSeparatedByString(" ")
        
        // At least a command input should by found
        guard !splitted.isEmpty && splitted.count > 0 else { throw InputParsingError.WrongInput(string) }
        
        // parse type
        let inputType = getFromKey(splitted[0], inputString: stripped)
        
        // Return nil if no type parsed
        guard inputType != nil else { throw  InputParsingError.WrongInput(string) }
        
        let args = Array(splitted[1..<splitted.count])
        let parsedArgs = try parseArgs(inputType!, args: args)
        
        //extract args
        return Input(type:inputType!, params: parsedArgs);
        
    }
    
    
    func parseArgs (inputType: InputType, args: [String]) throws -> [Any] {
        let expected = inputType.paramTypes.count
        let got = args.count
        
        guard got == expected else {
            throw InputParsingError.WrongArgumentNumber(inputType.description, expected, got)
        }
        var parsedArgs = [Any]()
        for index in 0..<args.count{
            let type = inputType.paramTypes[index];
            switch type {
            case .Number:
                let parsedArg = uint(args[index])
                guard parsedArg != nil else { throw InputParsingError.WrongArgumentValue(inputType.description, args[index]) }
                parsedArgs.append(parsedArg)
            default:
                parsedArgs.append(Character(args[index]))
            }
        }
        return parsedArgs
    }
    
    private func getFromKey(key: String, inputString: String) -> InputType? {
        switch key {
        case "C":
            return .CreateCanvas(inputString)
        case "L":
            return .CreateLine(inputString)
        case "R":
            return .CreateRect(inputString)
        case "B":
            return .BucketFill(inputString)
        default:
            return nil
        }
    }
    
    private func stripSpaces(string : String) -> String {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return components.filter { !$0.isEmpty }.joinWithSeparator(" ")
    }
}