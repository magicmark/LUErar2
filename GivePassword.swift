//
//  GivePassword.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

protocol AskForPasswordDelegate {
    func cancelUnarchiving ()
    func passwordGiven (password: String)
}

class GivePassword: NSWindowController {

    @IBOutlet weak var passwordBoc: NSTextField!
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    var delegate: AskForPasswordDelegate?
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.cancelUnarchiving()
        NSApp.endSheet(self.window!)
        self.window!.orderOut(nil)
    }

    @IBAction func go(sender: AnyObject) {
        delegate?.passwordGiven(passwordBoc!.stringValue)
        NSApp.endSheet(self.window!)
        self.window!.orderOut(nil)
    }

    func launchSheet () {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        NSApp.beginSheet(self.window!, modalForWindow: appDelegate.window.window!, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
    }
    
}
