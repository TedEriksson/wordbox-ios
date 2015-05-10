//
//  CreateSentenceViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 02/05/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit

class CreateSentenceViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var rows = 1
    
    @IBAction func closeCreate(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        var words = [String]()
        
        for index in 0...(rows - 1) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! WordCell
            words.append(cell.word.text)
        }
        NetworkClient.createSentence(words) { (success) -> () in
            self.closeCreate(nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("edit_word", forIndexPath: indexPath) as! WordCell
        cell.word.delegate = self
        return cell;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addNewRow(textField)
        return false
    }
    
    func addNewRow(textField: UITextField) {
        let list = tableView.numberOfRowsInSection(0)
        let indexPath = tableView.indexPathForCell(textField.superview!.superview as! UITableViewCell)
        let row = indexPath!.row
        if row == list - 1 {
            println("New Line")
            rows++
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: list, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: list, inSection: 0)) as! WordCell).word.select(nil)
        }
    }
}