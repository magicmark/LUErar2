//
//  Settings.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

enum Panel : Int {
    case Passwords   = 0
    case Archiving   = 1
    case Unarchiving = 2
}

class Settings: NSWindowController {

    var currentView: NSView?
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl?
    @IBOutlet weak var view: NSView?
    
    // View Controllers
    var passwords = Passwords(nibName: "Passwords", bundle: nil)!
    var archiving = Archiving(nibName: "Archiving", bundle: nil)!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.contentViewController?.addChildViewController(passwords)
        self.window?.contentViewController?.addChildViewController(archiving)
        loadPanel(Panel(rawValue: segmentedControl!.selectedSegment)!)
    }
    
    @IBAction func segmentedControlClicked(sender: AnyObject) {
        loadPanel(Panel(rawValue: segmentedControl!.selectedSegment)!)
    }
    
    func loadSubview(_view: NSView) {
        if self.currentView == nil {
            self.view?.addSubview(_view)
        } else {
            self.view?.replaceSubview(self.currentView!, with: _view)
        }
        self.currentView = _view
    }
    
    func loadPanel (panel: Panel) {
        switch (panel) {
        case .Passwords:
            loadSubview(passwords.view)
        case .Archiving:
            loadSubview(archiving.view)
        default:
            currentView?.removeFromSuperview()
            self.currentView = nil
        }
    }
    
}
