//
//  Unrar.swift
//  LUErar2
//
//  Created by Mark Larah on 02/02/2015.
//  Copyright (c) 2015 Kalphak. All rights reserved.
//

import Foundation

class Unrar: Operation {
    
    init(files: [String]) {
        super.init()
        
        executable = "\(currentExecutionPath)/Contents/Resources/unrar"
        
        args = [
            "e"
        ]
        
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
    
    func parseFiles (data: String) {
        // Probably a better way of doing this, idk this seems ok
        var regex = NSRegularExpression(pattern: "^Extracting( )+", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)
        var result = regex!.matchesInString(data, options: nil, range:NSMakeRange(0, countElements(data)))
        
        // aaah ok we can for sure do this whole function more efficiently. as ever, it'll do for now...
        if result.count == 1 {
            let file = (data as NSString).stringByReplacingOccurrencesOfString("^Extracting +", withString: "", options: .RegularExpressionSearch, range: NSMakeRange(0, countElements(data)))
            let url = NSURL(fileURLWithPath: file)
            let basename = url?.lastPathComponent
            if basename != nil {
                delegate?.setProgressText("Adding: \(basename!)")
            }
        }
    }
    
    override func dataAvailable (data: String) {
        println(data)
        parsePercentageDone(data)
        parseFiles(data)
    }
    
}