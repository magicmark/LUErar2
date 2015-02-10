//
//  SelectPassword.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

class SelectPassword: NSWindowController, NSComboBoxDataSource
{
    var delegate: SelectedPasswordDelegate?
    
    @IBOutlet weak var passwordBox: NSComboBox!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        passwordBox?.focusRingType = .None
    }
    
 
    func launchSheet () {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        NSApp.beginSheet(self.window!, modalForWindow: appDelegate.window.window!, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
        passwordBox?.selectItemAtIndex(0)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        NSApp.endSheet(self.window!)
        self.window!.orderOut(nil)
        delegate?.cancel()
    }
    
    @IBAction func go(sender: AnyObject) {
        NSApp.endSheet(self.window!)
        self.window!.orderOut(nil)
        delegate?.choose(passwordBox!.stringValue)
    }
 
    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return PasswordManager.sharedInstance.passwords.count
    }
    
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        return PasswordManager.sharedInstance.passwords[index]
    }

    
}
