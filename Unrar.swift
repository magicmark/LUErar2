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
    
    func parseCheckPassword (data: String) {
        // means there's a password error
        if data.rangeOfString("Checksum error in the encrypted file") != nil {
            badPassword = true
        }
    }
    
    override func dataAvailable (data: String) {
        parsePercentageDone(data)
        parseFiles(data, seatchString: "Extracting")
    }
    
    override func errorDataAvailable(data: String) {
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