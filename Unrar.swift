//
//  Unrar.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class Unrar: Operation {
        
    init(file: String, withPassword: String?) {
        super.init(files: [file])
        
        executable = "\(currentExecutionPath)/Contents/Resources/unrar"

        // Get Preferences stuff
        let destinationFolder = Preferences.sharedInstance.get("unarchiveDestination")! as String
        
        let destinationIsParent = (destinationFolder == "None" || Preferences.sharedInstance.get("unarchiveDestinationIsParent")! as Bool)

        let createFolder = Preferences.sharedInstance.get("createFolderForUnarchive")! as Bool
        
        var unarchivePath: String = "\(file.stringByDeletingLastPathComponent)/"
        if !destinationIsParent {
            unarchivePath = destinationFolder
        }
        
        if createFolder {
            unarchivePath += "\(file.lastPathComponent.stringByDeletingPathExtension)/"
        }
        
        args = [
            "e",
            "-y",
            (withPassword != nil) ? "-p\(withPassword!)" : "-p-",
            file,
            unarchivePath
        ]
        
    }
    
    var badPassword = false
    
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
                delegate?.setProgressText("Extracting: \(basename!)")
            }
        }
    }
    
    func parseCheckPassword (data: String) {
        // means there's a password error
        if data.rangeOfString("Checksum error in the encrypted file") != nil {
            badPassword = true
        }
    }
    
    override func dataAvailable (data: String) {
        println("all good- \(data)")
        parsePercentageDone(data)
        parseFiles(data)
    }
    
    override func errorDataAvailable(data: String) {
        println("hmm")
        println(data)
        parseCheckPassword(data)
    }
    
    override func taskEnded() {
        if badPassword {
            delegate?.reattempt()
        } else {
            delegate?.complete()
        }
    }
    
}