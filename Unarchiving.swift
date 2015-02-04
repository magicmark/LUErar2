//
//  Unarchiving.swift
//  LUErar2
//
//  Created by Mark on 04/02/2015.
//  Copyright (c) 2015. All rights reserved.
//

import Cocoa

class Unarchiving: NSViewController {

    @IBOutlet weak var createFolderCheckbox: NSButton?
    @IBOutlet weak var destinationCheckbox: NSButton?
    @IBOutlet weak var destinationPickerButton: NSButton!
    @IBOutlet weak var destinationLabel: NSTextField?
    
    var openPanel = NSOpenPanel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Setup choose folder panel
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.title = "Choose archive extraction destination"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = false
    }
    
    override func viewWillAppear () {
        
        super.viewWillAppear()
        
        // Set preferences
        createFolderCheckbox?.state = (Preferences.sharedInstance.get("createFolderForUnarchive")! as Bool) ? 1 : 0
        destinationCheckbox?.state = (Preferences.sharedInstance.get("unarchiveDestinationIsParent")! as Bool) ? 1 : 0
        destinationLabel?.stringValue = Preferences.sharedInstance.get("unarchiveDestination")! as String
        setStates()
        
    }
    
    @IBAction func createFolderSet(sender: AnyObject) {
        Preferences.sharedInstance.set((createFolderCheckbox?.state == 1), forKey: "createFolderForUnarchive")
    }
    
    @IBAction func unarchiveDestinationParentFolderSet(sender: AnyObject) {
        Preferences.sharedInstance.set((destinationCheckbox?.state == 1), forKey: "unarchiveDestinationIsParent")
        setStates()
    }
    
    @IBAction func pickDestination(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        openPanel.beginSheetModalForWindow(appDelegate.settings.window!, completionHandler: { result in
            if result == 1 {
                // Could probably do this by casting to NSUrl and just extracting path without protocol. Maybe this is a TODO
                var dest: String = self.openPanel.URLs[0].absoluteString!!
                dest = dest.stringByReplacingOccurrencesOfString("file://",
                    withString: "",
                    options: .LiteralSearch,
                    range: Range<String.Index>(start: dest.startIndex, end: advance(dest.startIndex, 7))
                )
                self.destinationLabel?.stringValue = dest
                Preferences.sharedInstance.set(dest, forKey: "unarchiveDestination")
            }
        })
    }
    
    func setStates() {
        if Preferences.sharedInstance.get("unarchiveDestinationIsParent")! as Bool {
            destinationPickerButton?.enabled = false
            destinationLabel?.hidden = true
        } else {
            destinationPickerButton?.enabled = true
            destinationLabel?.hidden = false
        }
    }
    
}
