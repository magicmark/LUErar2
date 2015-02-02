//
//  Passwords.swift
//  LUErar2
//
//  Created by Mark on 02/02/2015.
//  Copyright (c) 2015 Mark. All rights reserved.
//

import Cocoa

protocol PasswordManagerDelegate {
    func addedNewPassword(password: String)
    func editedPassword(position: Int, newPassword: String)
}

class Passwords: NSViewController, NSTableViewDelegate, NSTableViewDataSource, PasswordManagerDelegate {

    // TODO: Add a 'make default' button to move selected password to top of the list
    
    var managePasswordWindow = ManagePassword(windowNibName: "ManagePassword")

    
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here
        
        managePasswordWindow.delegate = self
//        
//        var potentialPasswords = appDelegate.loadPasswords()
//        if potentialPasswords != nil {
//            appDelegate.passwords = potentialPasswords!
//            tableView.reloadData()
//        }

    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return PasswordManager.sharedInstance.passwords.count
    }

    
    // I think this is the old way of doing it or something?
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return PasswordManager.sharedInstance.passwords[row]
    }
    
    @IBAction func addNew(sender: AnyObject) {
        managePasswordWindow.beginAddPassword()

    }

    @IBAction func editPassword(sender: AnyObject) {
        managePasswordWindow.beginEditPassword(tableView.selectedRow, currentPassword: PasswordManager.sharedInstance.passwords[tableView.selectedRow])
    }
    
    @IBAction func deletePassword(sender: AnyObject) {
        deletedPassword(tableView.selectedRow)
    }

    func deletePasswordConfirmation (passwordToDelete: String) -> Bool {
        let popup = NSAlert()
        popup.addButtonWithTitle("Yes")
        popup.addButtonWithTitle("No")
        popup.messageText = "Are you sure you want to delete the password '\(passwordToDelete)'?"
        popup.alertStyle = .CriticalAlertStyle
        return (popup.runModal() == NSAlertFirstButtonReturn)
    }
    
    func showAddedPasswordConfirmation () {
        let popup = NSAlert()
        popup.addButtonWithTitle("Gotcha")
        popup.messageText = "Password has been added."
        popup.alertStyle = .InformationalAlertStyle
        popup.runModal()
    }

    func showEditedPasswordConfirmation () {
        let popup = NSAlert()
        popup.addButtonWithTitle("Gotcha")
        popup.messageText = "Password has been changed."
        popup.alertStyle = .InformationalAlertStyle
        popup.runModal()
    }

    func showDeletedPasswordConfirmation () {
        let popup = NSAlert()
        popup.addButtonWithTitle("Gotcha")
        popup.messageText = "Password has been deleted."
        popup.alertStyle = .InformationalAlertStyle
        popup.runModal()
    }

    
    func showDidNotAddPasswordConfirmation () {
        // or maybe the file couldn't be written or something
        // TODO: Add other error messages amd types
        let popup = NSAlert()
        popup.addButtonWithTitle("Gotcha")
        popup.messageText = "Password was not added."
        popup.informativeText = "It's already in the list, foo"
        popup.alertStyle = .WarningAlertStyle
        popup.runModal()
    }
    
    
    func deletedPassword(position: Int) {
        if deletePasswordConfirmation(PasswordManager.sharedInstance.passwords[position]) {
            if PasswordManager.sharedInstance.deletePassword(position) {
                tableView.reloadData()
                showDeletedPasswordConfirmation()
            }
        }
    }
    
    // PasswordManagerDelegate
    
    func addedNewPassword(password: String) {
        if PasswordManager.sharedInstance.addPassword(password) {
            tableView.reloadData()
            showAddedPasswordConfirmation()
        } else {
            showDidNotAddPasswordConfirmation()
        }
    }
    
    func editedPassword(position: Int, newPassword: String) {
        if PasswordManager.sharedInstance.editPassword(position, newPassword: newPassword) {
            tableView.reloadData()
            showEditedPasswordConfirmation() // TODO: Maybe disable these confirmatinos, are they annoying?
        } else {
            showDidNotAddPasswordConfirmation()
        }
    }

}
