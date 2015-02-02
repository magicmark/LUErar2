//
//  DraggedFiles.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class DraggedFiles {
    
    // http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    class var sharedInstance: DraggedFiles {
        struct Static {
            static var instance: DraggedFiles?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DraggedFiles()
        }
        
        return Static.instance!
    }
    
    var filesQueue = [[String]]()
    
    func detectFilesType (files: [String]) -> ArchiveType {
        // Probably a better way of doing this, idk this seems ok
        var rarTypeRegex = NSRegularExpression(pattern: "(\\.rar)$", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)
        var result = rarTypeRegex!.matchesInString(files[0], options: nil, range: NSMakeRange(0, countElements(files[0])))
        return (result.count == 1) ? .Unrar : .Rar
    }
    
    func addFiles (files: [String]) {
        filesQueue.append(files)
    }
    
    // If there's some files to be rared or unrared, we can check from here and reciecve the operation
    func getFiles () -> [String]? {
        if filesQueue.count > 0 {
            let files = filesQueue.removeAtIndex(0)
            return files
        }
        return nil
    }
    
}