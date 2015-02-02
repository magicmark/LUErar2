//
//  dropper.swift
//  LUErar2
//
//  Created by Mark on 01/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa


protocol filesDraggedDelegate {
    func filesDragged(sender: NSDraggingInfo?)
}

class Dropper: NSImageView, NSDraggingDestination {

    var delegate: filesDraggedDelegate?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        sender.animatesToDestination = false
        super.draggingEntered(sender);
        var anim = FancyAnimation();
        self.image = NSImage(named: "hover")
        return sender.draggingSourceOperationMask()
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        sender?.animatesToDestination = false

        super.draggingExited(sender)
        self.image = NSImage(named: "lueshi")
    }

    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        sender?.animatesToDestination = false
        super.concludeDragOperation(sender)
        println("yoooo")
        self.image = NSImage(named: "lueshi")
        delegate?.filesDragged(sender)
    
    }
    
}
