//
//  FriendsViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var friends: List<User>?
    
    var parent: ViewController?
    
    var newFriendPopoverViewController: NewFriendPopover!
    
    func setViewController(vc: ViewController) {
        parent = vc
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        
        friends = parent?.user?.friends
        tableView.reloadData()
        spinner.stopAnimating()
        
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        
        newFriendPopoverViewController = storyboard.instantiateViewControllerWithIdentifier("NewFriendPopover") as! NewFriendPopover
        newFriendPopoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        newFriendPopoverViewController.preferredContentSize = CGSizeMake(250, 46)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = friends?.count {
            return Int(count) + 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Friend", forIndexPath: indexPath) as! FriendCell
        if indexPath.row == 0 {
            return cell
        }
        
        cell.username?.text = friends?[indexPath.row - 1].username
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            println("Add Friend")
            let cell: UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
            let popover = newFriendPopoverViewController.popoverPresentationController
            popover?.permittedArrowDirections = UIPopoverArrowDirection.Up
            popover?.delegate = self
            popover?.sourceView = cell
            popover?.sourceRect = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height - 10)
            parent!.navigationController!.presentViewController(newFriendPopoverViewController, animated: true, completion: nil)
        }
    }
    
    func updateUI(friends: List<User>) {
        self.friends = friends
        tableView?.reloadData()
        spinner?.stopAnimating()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return .None
    }
}