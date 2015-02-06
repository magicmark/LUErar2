//
//  Rar.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class Rar: Operation {
        
    init(files: [String], password: String?) {
        super.init(files: files)
        
        // Get Preferences stuff
        let rarLevel: Int = Preferences.sharedInstance.get("compressionAmount")! as Int
        let doRandomFileName = Preferences.sharedInstance.get("randomArchiveFileName")! as Bool
        let destinationIsParent = (Preferences.sharedInstance.get("archiveDestination")! == "None" || Preferences.sharedInstance.get("archiveDestinationIsParent")! as Bool)
        let destinationFolder = Preferences.sharedInstance.get("archiveDestination")! as String
        
        executable = "\(currentExecutionPath)/Contents/Resources/rar"
        
        args = [
            "a",
            "-ep1",
            "-m\(rarLevel)",
            "-o-",
            "-y"
        ]
        
        if password != nil {
            args.append("-hp\(password!)")
        }
        
        var filename = NSUUID().UUIDString
        filename = filename.substringToIndex(advance(filename.startIndex, 8))
        if !doRandomFileName {
            let url = NSURL(fileURLWithPath: files[0])
            let basename = url?.lastPathComponent
            if basename != nil {
                filename = basename!.stringByDeletingPathExtension
            }
        }
        filename += ".rar"
        
        let fullDestinationFilePath = "\((destinationIsParent) ? files[0].stringByDeletingLastPathComponent : destinationFolder)/\(filename)"
        
        args.append(fullDestinationFilePath) // file name
        args += files // files
        
    }
    
    override func dataAvailable (data: String) {
        parsePercentageDone(data)
        parseFiles(data, seatchString: "Adding")
    }
    
    override func errorDataAvailable (data: String) {
        println(data)
    }
}