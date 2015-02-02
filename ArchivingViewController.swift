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
    func complete()
}

enum ArchiveType {
    case Rar
    case Unrar
}

class ArchivingViewController: NSViewController, ActivityDelegate {

    var currentOperation: Shell?

    var navDelegate: NavigationDelegate?
    
    @IBOutlet weak var progressText: NSTextField?
    @IBOutlet weak var currentFile: NSTextField?
    @IBOutlet weak var progressIndicator: NSProgressIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // use usesThreadedAnimation?? TODO: find this out
        progressIndicator?.usesThreadedAnimation = true
    }
    
    override func viewWillAppear() {
        clearView()
    }
    
    func clearView () {
        progressIndicator?.startAnimation(nil)
        progressIndicator?.doubleValue = 0.0
        progressIndicator?.displayIfNeeded()
        setProgressText("dfg")
        setProgressAmount(0.0)
    }
    
    func start (type: ArchiveType, files: [String]) {
        clearView()
        if currentOperation == nil {

            if type == .Rar {
                var rarOp = Rar(files: files)
                rarOp.delegate = self
                currentOperation = Shell(operation: rarOp)
            } else {
                
            }
            



        }
    }
 
    func setProgressAmount(value: Double) {
        progressText?.stringValue = "\(Int(value))%"
        progressIndicator?.doubleValue = value
        progressIndicator?.displayIfNeeded()
    }
    
    func setProgressText(text: String) {
        currentFile?.stringValue = text
    }
    
    @IBAction func cancel(sender: AnyObject) {
        currentOperation?.cancel()
        complete()
    }
    
    func complete () {
        currentOperation = nil
        progressIndicator?.stopAnimation(nil)
        navDelegate?.goHome()
    }
    
}
