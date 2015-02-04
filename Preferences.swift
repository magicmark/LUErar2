//
//  Preferences.swift
//  LUErar2
//
//  Created by Mark on 04/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

/*
  Perhaps this is an entirely pointless class, and I could
  just call the NSUserDefaults methods in my other classes.
  However, at time of writing, I wanted to experiment with
  generics in Swift. This whole app is a bit of a learning
  excericse for me really.
*/

class Preferences {
    
    // http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    class var sharedInstance: Preferences {
        struct Static {
            static var instance: Preferences?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Preferences()
        }
        
        return Static.instance!
    }
    
    let appDefaults: [NSObject: AnyObject] = [
        // Archiving
        "compressionAmount"             : 3,
        "randomArchiveFileName"         : true,
        "archiveDestinationIsParent"    : true,
        "archiveDestination"            : "None",
        // Unarchiving
        "createFolderForUnarchive"      : true,
        "unarchiveDestinationIsParent"  : true,
        "unarchiveDestination"          : "None"
        
    ]
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init () {
        defaults.registerDefaults(appDefaults)
    }
    
    func get<T> (preference: String) -> T? {
        var potentialValue: Any?
        switch (preference) {
        // Archiving
        case "compressionAmount":
            potentialValue = defaults.integerForKey(preference)
        case "randomArchiveFileName":
            potentialValue = defaults.boolForKey("randomArchiveFileName")
        case "randomArchiveFileNameRow":
            potentialValue = (defaults.boolForKey("randomArchiveFileName")) ? 0 : 1
        case "archiveDestinationIsParent":
            potentialValue = defaults.boolForKey("archiveDestinationIsParent")
        case "archiveDestination":
            potentialValue = defaults.stringForKey("archiveDestination")
        // Unarchiving
        case "createFolderForUnarchive":
            potentialValue = defaults.boolForKey("createFolderForUnarchive")
        case "unarchiveDestinationIsParent":
            potentialValue = defaults.boolForKey("unarchiveDestinationIsParent")
        case "archiveDestination":
            potentialValue = defaults.stringForKey("unarchiveDestination")
        default:
            potentialValue = defaults.stringForKey(preference)
        }
        
        if potentialValue != nil {
            return potentialValue! as? T
        }
        
        return nil
    }
    
    func set<T> (preference: T!, forKey key: String) {
        switch (key) {
        // Archiving
        case "compressionAmount":
            defaults.setInteger(preference as Int, forKey: "compressionAmount")
        case "randomArchiveFileName":
            defaults.setBool(preference! as Bool, forKey: "randomArchiveFileName")
        case "randomArchiveFileNameRow":
            defaults.setBool(((preference! as Int) == 0), forKey: "randomArchiveFileName")
        case "archiveDestinationIsParent":
            defaults.setBool(preference! as Bool, forKey: "archiveDestinationIsParent")
        case "archiveDestination":
            defaults.setObject(preference as String, forKey: "archiveDestination")
        // Unarchiving
        case "createFolderForUnarchive":
            defaults.setBool(preference! as Bool, forKey: "createFolderForUnarchive")
        case "unarchiveDestinationIsParent":
            defaults.setBool(preference! as Bool, forKey: "unarchiveDestinationIsParent")
        case "unarchiveDestination":
            defaults.setObject(preference as String, forKey: "unarchiveDestination")
        default:
            defaults.setObject(preference as String, forKey: key)
        }
    }
    
    
}
