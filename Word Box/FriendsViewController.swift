//
//  FriendsViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit
import Realm

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var friends: RLMArray?
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = friends?.count {
            spinner?.stopAnimating()
            return Int(count)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Friend", forIndexPath: indexPath) as! FriendCell
        
        cell.username?.text = (friends?.objectAtIndex(UInt(indexPath.row)) as! User).username
        
        return cell
    }
    
    func updateUI(friends: RLMArray) {
        self.friends = friends
        
        tableView?.reloadData()
        spinner?.stopAnimating()
    }
}