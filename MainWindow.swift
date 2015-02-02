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

class MainWindow: NSWindowController, NavigationDelegate, filesDraggedDelegate {
    
    // Child view controllers
    var dragView    = DragView(nibName: "DragView", bundle: nil)!
    var archiver    = ArchivingViewController(nibName: "ArchivingViewController", bundle: nil)!
    
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
    
    func goHome () {
        if currSubviewPointer == nil {
            window?.contentView.addSubview(dragView.view)
            currSubviewPointer = dragView.view
        } else {
            window?.contentView.replaceSubview(currSubviewPointer!, with: dragView.view)
            currSubviewPointer = dragView.view
        }
    }
    
    func filesDragged(sender: NSDraggingInfo?) {

        // Was going to use enumerateDraggingItemsWithOptions, but I decided I didn't want to kill myself. Swift still isn't great...
        var pasteboard = sender!.draggingPasteboard()
        var allFiles: [String] = pasteboard.propertyListForType(NSFilenamesPboardType) as [String]
        
        // Probably a better way of doing this, idk this seems ok
        var rarTypeRegex = NSRegularExpression(pattern: "(\\.rar)$", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)
        var result = rarTypeRegex!.matchesInString(allFiles[0], options: nil, range:NSMakeRange(0, countElements(allFiles[0])))

        let type: ArchiveType = (result.count == 1) ? .Unrar : .Rar
        archiver.start(type, files: allFiles)
        
        // show before we start the archving process? idk
        window?.contentView.replaceSubview(dragView.view, with: archiver.view)
        currSubviewPointer = archiver.view
        
    }
    
}
