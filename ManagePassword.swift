//
//  ManagePassword.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

class ManagePassword: NSWindowController {

    @IBOutlet weak var passwordInput: NSTextField?
    @IBOutlet weak var actionButton: NSButton?
    
    var currPassword: Int?
    var delegate: PasswordManagerDelegate?
    
    // Dirty dirty hack. TODO: find the proper way to do this
    var isLoaded = false
    var titleToSet: String?
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Uuuuuuuch there has to be a better way
        isLoaded = true
        if titleToSet != nil {
            setActionButtonTitle(titleToSet!)
        }
        
        passwordInput?.focusRingType = .None

    
    }
    func setActionButtonTitle(title: String) {
        if isLoaded {
            actionButton?.title = title
        } else {
            titleToSet = title
        }
    }
    
    private func launchSheet () {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        NSApp.beginSheet(self.window!, modalForWindow: appDelegate.settings.window!, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
    }
    
    func beginEditPassword (position: Int, currentPassword: String) {
        currPassword = position
        setActionButtonTitle("Edit")
        launchSheet()
        passwordInput?.stringValue = currentPassword // ok whatever
        // TODO: REALLY, fix this ^
    }
    
    func beginAddPassword () {
        currPassword = nil
        setActionButtonTitle("Add")
        launchSheet()
    }
    
    @IBAction func go(sender: AnyObject) {
        NSApp.endSheet(window!)
        self.window!.orderOut(nil)
        let editedPassword: String? = passwordInput?.stringValue
        
        if editedPassword != nil {
            if currPassword == nil {
                delegate?.addedNewPassword(editedPassword!)
            } else {
                delegate?.editedPassword(currPassword!, newPassword: editedPassword!)
            }
        }
        
        passwordInput?.stringValue = ""
    }
    
    @IBAction func cancel(sender: AnyObject) {
        NSApp.endSheet(self.window!)
        self.window!.orderOut(nil)
        passwordInput?.stringValue = ""
    }
    
}
