//
//  Input.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/3/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/**
 *  Describes a parsed instruction
 */
struct Input {
    let type: InputType
    let params:[Any]
    let instruction: String
}

extension Input: Equatable {}

// MARK: Equatable
func ==(lhs: Input, rhs: Input) -> Bool
{
    guard lhs.type == rhs.type else { return false }
    guard lhs.params.count == rhs.params.count else { return false }
    
    var isEqual = true
    
    for index in 0..<lhs.params.count{
        isEqual = lhs.params[index] as? NSString == rhs.params[index] as? NSString
            && lhs.params[index] as? NSNumber == rhs.params[index] as? NSNumber
        if !isEqual { break }
    }
    return isEqual
}

/**
 Types of instructions supported
 
 - CreateCanvas:
 - CreateLine:
 - CreateRect:
 - BucketFill:
 */
enum InputType {
    
    case CreateCanvas
    case CreateLine
    case CreateRect
    case BucketFill
    
    /**
      Param types supported
     
     - String:
     - Number:
     */
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
//Cmparator overload


/**
 Types of Errors could be thrown on input parsing
 
 - WrongInput:
 - WrongArgumentNumber:
 - WrongArgumentValue:
 */
enum InputParsingError: ErrorType {
    case WrongInput(String)
    case WrongArgumentNumber(String, Int, Int)
    case WrongArgumentValue(String, String)
}

/**
 *  Defines the interface needed for a Input Builder / Parser
 */
protocol InputBuilder {
    /**
     Parses string instruction into [Input] struct
     
     - parameter string: plain instruction
     
     - throws: can throw any InputParsingError
     
     - returns: Input struct representing instruction
     */
    func parseInput (string: String) throws -> Input
}

/// Actual Input Builde instance
class InputCreator: InputBuilder {
    
    func parseInput(string: String) throws -> Input{
        let stripped = self.stripSpaces(string)
        let splitted = stripped.componentsSeparatedByString(" ")
        
        // At least a command input should by found
        guard !splitted.isEmpty && splitted.count > 0 else { throw InputParsingError.WrongInput(string) }
        
        // parse type
        let inputType = getFromKey(splitted[0])
        
        // Return error if no type parsed
        guard inputType != nil else { throw  InputParsingError.WrongInput(string) }
        
        let args = Array(splitted[1..<splitted.count])
        let parsedArgs = try parseArgs(inputType!, args: args)
        
        // Early check if line command is valid
        if inputType! == InputType.CreateLine{
            guard args[0]==args[2] || args[1]==args[3] else {
                throw InputParsingError.WrongArgumentValue(inputType!.description, args.joinWithSeparator(","))
            }
        }
        
        // Early check if rect command is valid
        if inputType! == InputType.CreateRect{
            guard args[0] != args[2] && args[1] != args[3] else {
                throw InputParsingError.WrongArgumentValue(inputType!.description, args.joinWithSeparator(","))
            }
        }
        
        //extract args
        return Input(type:inputType!, params: parsedArgs, instruction: stripped);
    }
    
    
    private func parseArgs (inputType: InputType, args: [String]) throws -> [Any] {
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
                guard (args[index]).characters.count == 1 else {
                    throw InputParsingError.WrongArgumentValue(inputType.description, args[index]) }
                parsedArgs.append(Character(args[index]))
            }
        }
        return parsedArgs
    }
    
    /**
     Creates the enumeration instance from key associated
     
     - parameter key:         C, L, R, B
     - parameter inputString: Actual command parsed, just for store it
     
     - returns: Enum instance
     */
    private func getFromKey(key: String) -> InputType? {
        switch key {
        case "C":
            return .CreateCanvas
        case "L":
            return .CreateLine
        case "R":
            return .CreateRect
        case "B":
            return .BucketFill
        default:
            return nil
        }
    }
    
    private func stripSpaces(string : String) -> String {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return components.filter { !$0.isEmpty }.joinWithSeparator(" ")
    }
}