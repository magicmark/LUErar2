//
//  Shell.swift
//  LUErar2
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class Operation: NSObject {
    // TODO: tidy all this up
    var args = [String]()
    var executable = ""
    let currentPath = NSFileManager.defaultManager().currentDirectoryPath
    let currentExecutionPath = NSBundle.mainBundle().bundlePath
    var delegate: ActivityDelegate?
    func dataAvailable (data: String) { }
    func taskEnded () {
        delegate?.complete()
    }
}

class Shell: NSObject {
    
    var task = NSTask()
    var pipe = NSPipe()
    
    init (operation: Operation) {
        super.init()
        
        //var thread = NSThread(target: self, selector: "ummmmm", object: self)
        task.launchPath = operation.executable
        task.arguments  = operation.args
        task.standardOutput = pipe
        
        task.standardOutput.fileHandleForReading.readabilityHandler = { file in
            var data = NSString(data: file.availableData, encoding: NSUTF8StringEncoding)!
            operation.dataAvailable(data)
        }
        
        task.standardError = NSPipe()
        
        task.standardError.fileHandleForReading.readabilityHandler = { file in
            var data = NSString(data: file.availableData, encoding: NSUTF8StringEncoding)!
            println("error!: \(data)")
        }
        
        task.terminationHandler = { (task: NSTask!) in
            self.resetTaskHandlers()
            operation.taskEnded()
        }
        
        task.launch()
        
    }
    
    func resetTaskHandlers () {
        task.standardOutput.fileHandleForReading.readabilityHandler = nil
        task.standardError.fileHandleForReading.readabilityHandler = nil
    }
    
    func cancel () {
        task.terminate()
        resetTaskHandlers()
    }
    
    
}