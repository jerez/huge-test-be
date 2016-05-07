//
//  Buffer.swift
//  DrawingTool
//
//  Created by Carlos Jerez on 5/6/16.
//  Copyright © 2016 Huge. All rights reserved.
//

import Foundation

/**
 *  Helper Entity that stores output results to be printed later
 */
protocol OutputBuffer {
    /**
     Stores a log entry
     */
    func log(string: String)
    
    /**
     Appends content to the buffer
    */
    func appendToBuffer(string: String)
    func toScreen();
    func toFile() throws -> String;
}


class StringBuffer: OutputBuffer {
    
    private var _internalBuffer: [String] = [];
    private var _internalLog: [String] = [];
    
    func log(string: String) {
        _internalLog.append(string);
    }
    
    func appendToBuffer(string: String) {
        _internalBuffer.append(string)
        log(string)
    }
    
    /**
     Prints buffer content into screen
     */
    func toScreen() {
        print(self._internalLog.joinWithSeparator("\n"));
    }
    
    /**
     Sends buffer content to output.txt file
     */
    func toFile() throws -> String {
        let filMgr = FileIO()
        let logName  = try filMgr.writeFile("log_dt_\(NSDate().formattedISO8601).txt", content: self._internalLog)
        let outName = try filMgr.writeOutput(self._internalBuffer)
        return ("\n output: \(outName) \n log: \(logName)")
    }
}

extension NSDate {
    struct Date {
        static let formatterISO8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            return formatter
        }()
    }
    var formattedISO8601: String { return Date.formatterISO8601.stringFromDate(self) }
}
