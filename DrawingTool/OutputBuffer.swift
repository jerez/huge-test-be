//
//  StringBuffer.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/5/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation


class OutputBuffer {
    
    private var _internalBuffer: [String] = [];
    private var _consoleLog: [String] = [];
    
    static let sharedInstance = OutputBuffer()
    private init() {}
    
    func log(string: String) {
        _consoleLog.append(string);
        print(string)
    }
    
    func append(string: String) {
        _internalBuffer.append(string)
        log(string)
    }
    
    func append(array: [String]) {
        _internalBuffer.appendContentsOf(array)
        array.forEach { log($0) }
    }
}