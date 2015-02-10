//
//  Shell.swift
//  LUErar2
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class Shell: NSObject {
    
    // TODO: messing with shell calls is risky stuff - make sure we're removing references and stuff when operations are finished
    
    var task = NSTask()
    var stdoutPipe = NSPipe()
    var stderrPipe = NSPipe()
    
    init (operation: Operation) {
        super.init()
        
        task.launchPath = operation.executable!
        task.arguments  = operation.args!
        task.standardOutput = stdoutPipe
        task.standardError  = stderrPipe
        
        task.standardOutput.fileHandleForReading.readabilityHandler = { file in
            var data = NSString(data: file.availableData, encoding: NSASCIIStringEncoding)!
            operation.dataAvailable(data)
        }
        
        task.standardError.fileHandleForReading.readabilityHandler = { file in
            var data = NSString(data: file.availableData, encoding: NSASCIIStringEncoding)!
            operation.errorDataAvailable(data)
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