//
//  Operation.swift
//  LUErar2
//
//  Created by Mark on 06/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

// How to make this an abstract class?
class Operation  {

    var destination: String?
    var executable:  String?
    var files:       [String]
    var args:        [String]?
    var delegate:    ActivityDelegate?
    
    let currentExecutionPath = NSBundle.mainBundle().bundlePath
    let currentPath          = NSFileManager.defaultManager().currentDirectoryPath
    var shouldReattempt      = false
    
    init (files: [String]) {
        self.files = files
        assert(files != [], "Operation requires files")
    }
    
    func dataAvailable (data: String) {
        parsePercentageDone(data)
        parseFiles(data)
    }
    
    func errorDataAvailable (data: String) {
        println(data)
    }
    
    func taskEnded () {
        delegate?.finishedOperation(false)
    }
    
    func parsePercentageDone (data: String) {
        // Probably a better way of doing this, idk this seems ok
        let regex = NSRegularExpression(pattern: "([0-9]+%)$", options: .AnchorsMatchLines, error: nil)
        let result = regex!.matchesInString(data, options: nil, range: NSMakeRange(0, countElements(data)))
        
        if result.count == 1 {
            var percentage = (data as NSString).substringWithRange(result[0].rangeAtIndex(1)) // get 40%
            percentage = percentage.substringToIndex(advance(percentage.startIndex, countElements(percentage) - 1)) // get 40
            let number: Int? = percentage.toInt()
            if number != nil {
                delegate?.setProgressAmount(Double(number!))
            }
        }
    }
    
    func parseFiles (data: String) {
        
        let seatchString = (self.dynamicType === Rar.self) ? "Adding" : "Extracting";
        
        // Probably a better way of doing this, idk this seems ok
        let regex = NSRegularExpression(pattern: "^\(seatchString)( )+", options: .AnchorsMatchLines, error: nil)
        let result = regex!.matchesInString(data, options: nil, range:NSMakeRange(0, countElements(data)))
        
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