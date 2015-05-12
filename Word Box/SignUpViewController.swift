//
//  SignUpViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 12/05/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func navCancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func navDone(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        
        NetworkClient.createNewUser(email.text, username: username.text, password: password.text) { (user, errors) -> () in
            SVProgressHUD.dismiss()
            if let user = user {
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                var alert = UIAlertView(title: "Error", message: errors?.description, delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}