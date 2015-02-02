//
//  Settings.swift
//  LUErar2
//
//  Created by Mark Larah on 02/02/2015.
//  Copyright (c) 2015 Kalphak. All rights reserved.
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
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.contentViewController?.addChildViewController(passwords)
        loadPanel(Panel(rawValue: segmentedControl!.selectedSegment)!)
    }
    
    @IBAction func segmentedControlClicked(sender: AnyObject) {
        loadPanel(Panel(rawValue: segmentedControl!.selectedSegment)!)
    }
    
    func loadSubview(_view: NSView) {
        if currentView == nil {
            view?.addSubview(_view)
        } else {
            view?.replaceSubview(currentView!, with: _view)
        }
    }
    
    func loadPanel (panel: Panel) {
        switch (panel) {
        case .Passwords:
            loadSubview(passwords.view)
        default:
            currentView?.removeFromSuperview()
        }
    }
    
}
