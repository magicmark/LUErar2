//
//  Archiving.swift
//  LUErar2
//
//  Created by Mark on 04/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

class Archiving: NSViewController {

    
    @IBOutlet weak var compressionSlider: NSSlider?
    @IBOutlet weak var filenameRadioButtons: NSMatrix?
    @IBOutlet weak var destinationCheckbox: NSButton?
    @IBOutlet weak var destinationPickerButton: NSButton?
    @IBOutlet weak var destinationLabel: NSTextField?
    
    var openPanel = NSOpenPanel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Setup choose folder panel
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.title = "Choose destination for Archives"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = false
    }
    
    override func viewWillAppear () {
        
        super.viewWillAppear()
        
        // Set preferences
        compressionSlider?.integerValue = Preferences.sharedInstance.get("compressionAmount")! as Int
        filenameRadioButtons?.selectCellAtRow(Preferences.sharedInstance.get("randomArchiveFileNameRow")! as Int, column: 0)
        destinationCheckbox?.state = (Preferences.sharedInstance.get("archiveDestinationIsParent")! as Bool) ? 1 : 0
        destinationLabel?.stringValue = Preferences.sharedInstance.get("archiveDestination")! as String
        setStateOfSelectFolderButtonAndDestinationLabelForthwith()
        
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        Preferences.sharedInstance.set(compressionSlider?.integerValue, forKey: "compressionAmount")
    }
    
    @IBAction func fileNameSourceChanged(sender: AnyObject) {
        Preferences.sharedInstance.set(filenameRadioButtons?.selectedRow, forKey: "randomArchiveFileNameRow")
    }
    
    @IBAction func archiveDestinationParentFolderSet(sender: AnyObject) {
        Preferences.sharedInstance.set((destinationCheckbox?.state == 1), forKey: "archiveDestinationIsParent")
        setStateOfSelectFolderButtonAndDestinationLabelForthwith()
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
                Preferences.sharedInstance.set(dest, forKey: "archiveDestination")
            }
        })
    }
    
    func setStateOfSelectFolderButtonAndDestinationLabelForthwith () {
        if Preferences.sharedInstance.get("archiveDestinationIsParent")! as Bool {
            destinationPickerButton?.enabled = false
            destinationLabel?.hidden = true
        } else {
            destinationPickerButton?.enabled = true
            destinationLabel?.hidden = false
        }
    }
    
}
