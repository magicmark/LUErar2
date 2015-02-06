//
//  Operation.swift
//  LUErar2
//
//  Created by Mark on 06/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class Operation  {
    // TODO: tidy all this up and fix the awful method names
    var args = [String]()
    var files = [String]()
    var executable = ""
    let currentPath = NSFileManager.defaultManager().currentDirectoryPath
    let currentExecutionPath = NSBundle.mainBundle().bundlePath
    var delegate: ActivityDelegate?
    func dataAvailable (data: String) { }
    var shouldReattempt = false
    func errorDataAvailable (data: String) {
        println(data)
    }
    func taskEnded () {
        delegate?.complete()
    }
    
    init (files: [String]) {
        self.files = files
    }
    
    func parsePercentageDone (data: String) {
        // Probably a better way of doing this, idk this seems ok
        var regex = NSRegularExpression(pattern: "([0-9]+%)$", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)
        var result = regex!.matchesInString(data, options: nil, range:NSMakeRange(0, countElements(data)))
        
        if result.count == 1 {
            var percentage = (data as NSString).substringWithRange(result[0].rangeAtIndex(1)) // get 40%
            percentage = percentage.substringToIndex(advance(percentage.startIndex, countElements(percentage) - 1)) // get 40
            var number: Int? = percentage.toInt()
            if number != nil {
                delegate?.setProgressAmount(Double(number!))
            }
        }
    }
    
    func parseFiles (data: String, seatchString: String) {
        // Probably a better way of doing this, idk this seems ok
        var regex = NSRegularExpression(pattern: "^\(seatchString)( )+", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)
        var result = regex!.matchesInString(data, options: nil, range:NSMakeRange(0, countElements(data)))
        
        // aaah ok we can for sure do this whole function more efficiently. as ever, it'll do for now...
        if result.count == 1 {
            let file = (data as NSString).stringByReplacingOccurrencesOfString("^\(seatchString) +", withString: "", options: .RegularExpressionSearch, range: NSMakeRange(0, countElements(data)))
            let url = NSURL(fileURLWithPath: file)
            let basename = url?.lastPathComponent
            if basename != nil {
                delegate?.setProgressText("\(seatchString): \(basename!)")
            }
        }
    }
    
}