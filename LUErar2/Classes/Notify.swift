//
//  Notifications.swift
//  LUErar2
//
//  Created by Mark on 09/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation
import AppKit

// TODO: Make settings pane to ask to display notifications or not

class Notify: NSObject {
    
    // http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    class var sharedInstance: Notify {
        struct Static {
            static var instance: Notify?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Notify()
        }
        
        return Static.instance!
    }
    
    let notificationCentre = NSUserNotificationCenter.defaultUserNotificationCenter()

    override init () {
        super.init()
        notificationCentre.delegate = self
    }
    
    func finished (filePath: String, type: ArchiveType) {
        var notification = NSUserNotification()
        notification.title = "Finished :)"
        notification.informativeText = (type == .Rar) ? "Your files have been archived." : "Your files have been unarchived."
        notification.userInfo = [ "filePath" : filePath ]
        notificationCentre.deliverNotification(notification)
    }
    
    func filesAdded () {
        var notification = NSUserNotification()
        notification.title = "Files added!"
        notification.informativeText = "Your files have been added to the procesing queue."
        notificationCentre.deliverNotification(notification)
    }
    
}

// MARK - NSUserNotificationCenterDelegate
extension Notify: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        NSWorkspace.sharedWorkspace().selectFile(notification.userInfo!["filePath"]! as String, inFileViewerRootedAtPath: "")
    }

    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }

}