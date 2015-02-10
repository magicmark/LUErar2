//
//  MainWindow.swift
//  LUErar2
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

/*

MainWindow.xib - shouldn't really exist. It's a dirty hack for now.
Basically, when the window was defined in code, no matter what I tried I couldn't
get the reference to it to add any subviews or anything. Maybe I was just doing
something silly, or idk, but this works for now, plus I can set some stuff a bit easier in IB.

*/

import Cocoa

protocol NavigationDelegate {
    func goHome ()
}

protocol SelectedPasswordDelegate {
    func choose(password: String)
    func cancel()
}

class MainWindow: NSWindowController {
    
    // Child view controllers
    var dragView    = DragView(nibName: "DragView", bundle: nil)!
    var archiver    = ArchivingViewController(nibName: "ArchivingViewController", bundle: nil)!

    var doingOperation = false
    var currSubviewPointer: NSView?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        dragView.delegate = self
        goHome()

        // Is this the best time and place to do this stuff? Do I even need to do this? I think I do. I have no idea what i'm doing
        self.window?.contentViewController?.addChildViewController(dragView)
        self.window?.contentViewController?.addChildViewController(archiver)
        
        archiver.navDelegate = self
    }
    
    func startArchiving () {
        // Should really do this logic elsewhere?
        if !doingOperation {
            // show before we start the archving process? idk
            dispatch_async(dispatch_get_main_queue(), {
                self.window?.contentView.replaceSubview(self.currSubviewPointer!, with: self.archiver.view)
                self.currSubviewPointer = self.archiver.view
                self.archiver.checkForFiles()
            })
            doingOperation = true
        } else {
            Notify.sharedInstance.filesAdded()
        }
    }
    
}

// MARK - NavigationDelegate
extension MainWindow: NavigationDelegate {
    
    func goHome () {
        dispatch_async(dispatch_get_main_queue(), {
            if self.currSubviewPointer == nil {
                self.window?.contentView.addSubview(self.dragView.view)
            } else {
                self.window?.contentView.replaceSubview(self.currSubviewPointer!, with: self.dragView.view)
            }
            self.currSubviewPointer = self.dragView.view
        })
        doingOperation = false
    }

}

// MARK - filesDraggedDelegate
extension MainWindow: filesDraggedDelegate {
    
    func filesDragged(sender: NSDraggingInfo?) {
        // Was going to use enumerateDraggingItemsWithOptions, but I decided it wasn't worth it...
        var pasteboard = sender!.draggingPasteboard()
        var allFiles: [String] = pasteboard.propertyListForType(NSFilenamesPboardType) as [String]
        
        DraggedFiles.sharedInstance.addFiles(allFiles)
        startArchiving()
    }

}
