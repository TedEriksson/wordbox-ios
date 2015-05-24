//
//  NewFriendPopover.swift
//  Word Box
//
//  Created by Ted Eriksson on 12/05/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class NewFriendPopover: UIViewController {
    
    var user: User!

    var vc : UIViewController!
    
    @IBOutlet weak var username: UITextField!
    @IBAction func addFriend(sender: AnyObject) {
        if !username.text.isEmpty {
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
            NetworkClient.addFriend(user.id, username: username.text, callback: { (success) -> () in
                SVProgressHUD.dismiss()
                if success {
                    let alert = UIAlertView(title: "Friend Request", message: "Request sent", delegate: nil, cancelButtonTitle: "Okay")
                    alert.show()
                } else {
                    let alert = UIAlertView(title: "Friend Request", message: "Request failed, try again", delegate: nil, cancelButtonTitle: "Okay")
                    alert.show()
                }
            })
            
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Error", message: "Username can't be empty", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
}