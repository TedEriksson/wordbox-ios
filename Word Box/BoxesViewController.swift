//
//  BoxesViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit
import Realm

class BoxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var sentences: RLMArray?
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = sentences?.count {
            return Int(count)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Box", forIndexPath: indexPath) as! SentenceCell
        
        cell.title?.text = (sentences?.objectAtIndex(UInt(indexPath.row)) as! Sentence).getWordsAsString()
        
        return cell
    }
    
    func updateUI(sentences: RLMArray) {
        self.sentences = sentences
        
        spinner?.stopAnimating()
        tableView?.reloadData()
    }
}