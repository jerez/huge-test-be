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

enum InputParsingError: ErrorType {
    case WrongInput(String)
    case WrongArgumentNumber(String, Int, Int)
    case WrongArgumentValue(String, String)
}

protocol InputBuilder {
    func parseInput (string: String) throws -> Input
    func parseArgs (inputType: InputType, args: [String]) throws -> [Any]
}

class InputCreator: InputBuilder {
    func parseInput(string: String) throws -> Input{
        let stripped = self.stripSpaces(string)
        let splitted = stripped.componentsSeparatedByString(" ")
        
        // At least a command input should by found
        guard !splitted.isEmpty && splitted.count > 0 else { throw InputParsingError.WrongInput(string) }
        
        // parse type
        let inputType = getFromKey(splitted[0], inputString: stripped)
        
        // Return error if no type parsed
        guard inputType != nil else { throw  InputParsingError.WrongInput(string) }
        
        let args = Array(splitted[1..<splitted.count])
        let parsedArgs = try parseArgs(inputType!, args: args)
        
        //extract args
        return Input(type:inputType!, params: parsedArgs);
        
    }
    
    
    func parseArgs (inputType: InputType, args: [String]) throws -> [Any] {
        let expected = inputType.paramTypes.count
        let got = args.count
        // Validate that param numbers are the same as defined for command
        guard got == expected else {
            throw InputParsingError.WrongArgumentNumber(inputType.description, expected, got)
        }
        // Parse 1 by 1 parameters in string command
        var parsedArgs = [Any]()
        for index in 0..<args.count{
            let type = inputType.paramTypes[index];
            switch type {
            case .Number:
                let parsedArg = uint(args[index])
                // Coordinate params should be number greaters than 0
                guard parsedArg != nil && parsedArg > 0
                    else { throw InputParsingError.WrongArgumentValue(inputType.description, args[index]) }
                parsedArgs.append(parsedArg)
            default:
                // Only accept 1 character as colors
                guard (args[index]).characters.count == 1 else { throw InputParsingError.WrongArgumentValue(inputType.description, args[index]) }
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