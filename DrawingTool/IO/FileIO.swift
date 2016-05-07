//
//  FileIO.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/// Helper class to Read / Write Files
class FileIO {
    
    private static let _defaultOutput: String = "output.txt"
    private static let _defaultInput: String = "input.txt"
    
    func writeOutput(content: [String]) throws -> String {
        return try writeFile(FileIO._defaultOutput, content: content)
    }
    
    func readInput() throws -> [String] {
        return try self.readFile(FileIO._defaultInput)
    }
    
    func writeFile(fileName: String, content: [String]) throws -> String{
        let currentDir = NSBundle.mainBundle().bundlePath
        let path = NSURL(fileURLWithPath: currentDir).URLByAppendingPathComponent(fileName).path
        
        let stringContent = content.joinWithSeparator("\n")
        
        try stringContent.writeToFile(fileName, atomically: true, encoding: NSUTF8StringEncoding)
        
        return path!
    }
    
    func readFile(fileName: String) throws -> [String] {
        let currentDir = NSBundle.mainBundle().bundlePath
        let path = NSURL(fileURLWithPath: currentDir).URLByAppendingPathComponent(fileName)
        let content = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
        return content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
}
