//
//  ResolveLoginViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 09/05/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit

class ResolveLoginViewController: UIViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let email = defaults.objectForKey("email") as? String
        let password = defaults.objectForKey("password") as? String
        
        if let email = email, let password = password {
            NetworkClient.loginUser(email, password: password) { (user) -> () in
                self.loadNextView(user)
            }
        } else {
            loadNextView(nil)
        }
    }
    
    func loadNextView(user: User?) {
        if let user = user {
            println(user)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! ViewController
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            println("Bad Login")
//            if (self.navigationController?.topViewController.isKindOfClass(LoginViewController) != nil) {
//                println("Pop")
//                self.navigationController?.popViewControllerAnimated(true)
//            } else {
                println("Login")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let home = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(home, animated: true)
//            }
        }
    }
}