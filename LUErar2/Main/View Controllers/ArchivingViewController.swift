//
//  ArchivingViewController.swift
//  LUErar2
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

protocol ActivityDelegate {
    func setProgressAmount(value: Double)
    func setProgressText(text: String)
    func finishedOperation(shouldRetry: Bool)
}

enum ArchiveType {
    case Rar
    case Unrar
}

class CurrentRun {
    var shell: Shell?
    var operation: Operation?
    var type: ArchiveType // possibly don't need this param
    var attempt: Int
    
    init(operation: Operation, type: ArchiveType, attempt: Int) {
        self.operation = operation
        self.shell = Shell(operation: operation)
        self.type = type
        self.attempt = attempt
    }
}

class ArchivingViewController: NSViewController {

    var currentRun: CurrentRun?

    var acceptNewFiles = false
    // TODO: Move this and above maybe to currentOperation
    var filesToRarWithPassword: [String]?
    var filesToUnrarWithPassword: [String]? // TODO: combine these variables
    var attemptNumber = 0
    
    
    var navDelegate: NavigationDelegate?
    
    // OK, not sure why I had to do this - was getting
    var progressText: NSTextField?
    var currentFile: NSTextField?
//    @IBOutlet weak var progressText: NSTextField!
//    @IBOutlet weak var currentFile: NSTextField!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator?
    
    // Windows
    // TODO: rename these better so they're less confusing
    var askPassword = SelectPassword(windowNibName: "SelectPassword")
    var givePassword = GivePassword(windowNibName: "GivePassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressText = self.view.viewWithTag(1) as? NSTextField
        currentFile = self.view.viewWithTag(2) as? NSTextField
        
        // use usesThreadedAnimation?? TODO: find this out
        progressIndicator?.usesThreadedAnimation = true
        askPassword.delegate = self
        givePassword.delegate = self
    }
    
    override func viewWillAppear() {
        clearView()
    }
    
    func clearView () {
        progressIndicator?.startAnimation(nil)
        progressIndicator?.doubleValue = 0.0
        progressIndicator?.displayIfNeeded()
        setProgressText("Starting...")
        setProgressAmount(0.0)
    }
    
    func cancelCurrentOperation() {
        currentRun?.shell?.cancel()
        finishedOperation(false)
    }
    
    func checkForFiles () -> Bool {
        var files = DraggedFiles.sharedInstance.getFiles()
        if files != nil {
            if DraggedFiles.sharedInstance.detectFilesType(files!) == .Unrar {
                // If it's a rar, we want to process them one at a time.
                // Take out the first file, and put the rest back into the queue.
                var fileToUnrar = files!.removeAtIndex(0)
                if files!.count > 0 {
                    DraggedFiles.sharedInstance.addFiles(files!)
                }
                start(.Unrar, files: [fileToUnrar], attempt: 0, password: nil)
            } else {
                askRarPassword(files!)
            }
            return true
        }
        return false
    }
    
    func askRarPassword (files: [String]) {
        acceptNewFiles = false
        filesToRarWithPassword = files
        askPassword.launchSheet()
    }
    
    func start (type: ArchiveType, files: [String], attempt: Int, password: String?) {
        clearView()
        if currentRun == nil {

            acceptNewFiles = true
            
            if type == .Rar {
                var rarOp = Rar(files: files, password: password)
                rarOp.delegate = self
                currentRun = CurrentRun(operation: rarOp, type: .Rar, attempt: attempt)
            } else {
                var unrarOp = Unrar(file: files[0], withPassword: password)
                unrarOp.delegate = self
                currentRun = CurrentRun(operation: unrarOp, type: .Unrar, attempt: attempt)
            }
            
        }
    }
 
    @IBAction func cancel(sender: AnyObject) {
        cancelCurrentOperation()
    }
    
    func reattempt () {
        let files: [String] = currentRun!.operation!.files
        let attempt: Int = currentRun!.attempt + 1
        currentRun = nil
        let password = PasswordManager.sharedInstance.getPasswordForAttempt(attempt)
        if password != nil {
            start(.Unrar, files: files, attempt: attempt, password: password!)
        } else {
            attemptNumber = attempt
            filesToUnrarWithPassword = files
            askPasswordForUnrar()
        }
    }
    
    
    func askPasswordForUnrar () {
        givePassword.launchSheet()
    }

}

// MARK - ActivityDelegate
extension ArchivingViewController: ActivityDelegate {
    
    func setProgressAmount(value: Double) {
        progressText?.stringValue = "\(Int(value))%"
        progressIndicator?.doubleValue = value
        progressIndicator?.displayIfNeeded()
    }
    
    func setProgressText(text: String) {
        currentFile?.stringValue = text
    }
    
    func finishedOperation (shouldRetry: Bool) {
        if shouldRetry {
            reattempt()
        } else {
            if currentRun != nil {
                currentRun = nil
                progressIndicator?.stopAnimation(nil)
            }
            
            if !checkForFiles() {
                navDelegate?.goHome()
            }
        }
    }
    
}

// MARK - SelectedPasswordDelegate
extension ArchivingViewController: SelectedPasswordDelegate {
    
    func choose (password: String) {
        let trimmed  = password.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        if filesToRarWithPassword != nil {
            start(.Rar, files: filesToRarWithPassword!, attempt: 0, password: (trimmed == "") ? nil : trimmed)
            filesToRarWithPassword = nil
        }
    }
    
    func cancel() {
        cancelCurrentOperation()
    }

}

// MARK - AskForPasswordDelegate
extension ArchivingViewController: AskForPasswordDelegate {
    
    func cancelUnarchiving () {
        cancelCurrentOperation()
    }
    
    func passwordGiven (password: String) {
        if filesToUnrarWithPassword != nil {
            start(.Unrar, files: filesToUnrarWithPassword!, attempt: attemptNumber, password: password)
        }
    }
    
}
