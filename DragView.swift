//
//  DragView.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

class DragView: NSViewController, filesDraggedDelegate {

    var delegate: filesDraggedDelegate?
    
    @IBOutlet weak var dropper: Dropper!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropper!.delegate = self
    }
    
    
    func filesDragged(sender: NSDraggingInfo?) {
        delegate?.filesDragged(sender)
    }
    
    @IBAction func showSettings (sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        appDelegate.openPreferences(self)
    }
    
}
