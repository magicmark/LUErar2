//
//  PasswordManager.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Foundation

class PasswordManager {
    
    // http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    class var sharedInstance: PasswordManager {
        struct Static {
            static var instance: PasswordManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PasswordManager()
        }
        
        return Static.instance!
    }
    
    let path = "\(NSBundle.mainBundle().bundlePath)/Contents/Resources/passwords.txt"
    var passwords: [String]
    
    init () {
        passwords = []
        var potentialPasswords = loadPasswords()
        if potentialPasswords != nil {
            passwords = potentialPasswords!
        }
    }
    
    func loadPasswords () -> [String]? {
        let passwordFile = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        if passwordFile != nil {
            return passwordFile!.stringByTrimmingCharactersInSet(.newlineCharacterSet()).componentsSeparatedByCharactersInSet(.newlineCharacterSet())
        }
        return nil
    }
    
    func addPassword (password: String) -> Bool {
        // TODO: Send out NSNotification about this to update other parts of app maybe
        for existingPassword in passwords {
            if existingPassword == password {
                return false
            }
        }
        passwords.append(password)
        writePasswordsToFile()
        // TODO if else here based on writePasswordsToFile()
        return true
    }
    
    func editPassword (position: Int, newPassword: String) -> Bool {
        for existingPassword in passwords {
            if existingPassword == newPassword {
                return false
            }
        }
        // TODO: make sure position is sensible to ensure we don't mess anything up
        passwords[position] = newPassword
        writePasswordsToFile()
        return true
    }
    
    func deletePassword (position: Int) -> Bool {
        passwords.removeAtIndex(position)
        writePasswordsToFile()
        return true
    }
    
    func writePasswordsToFile () {
        let implodedPasswords = "\n".join(passwords) // should the join really just be \n? Or if there a special NSCharacter set or something to ensure this works universally
        // TODO: handle the error if any properly and inform user.
        // TODO: Make this function return true/false with success of writing to file, inform addPassword function
        implodedPasswords.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    }

    // if attempt = 0, it tried without password
    // 1-n = try from passowrd list
    // n+ = return nil, ask for password
    func getPasswordForAttempt(attempt: Int) -> String? {
        if passwords.count > attempt - 1 {
            return passwords[attempt - 1]
        }
        return nil
    }
    
}