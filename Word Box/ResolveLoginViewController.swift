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
    var autoSignIn = false
    
    var email: String?
    var password: String?
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func signInUser(email: String?, password: String?) {
        autoSignIn = true
        self.email = email
        self.password = password
    }
    
    override func viewDidAppear(animated: Bool) {
        if autoSignIn {
            println("Sign in")
            if let email = email, let password = password {
                NetworkClient.loginUser(email, password: password) { (user) -> () in
                    self.loadNextView(user)
                }
            } else {
                loadNextView(nil)
            }
        } else {
            println("Auto Sign in")
            NetworkClient.updateLoggedInUser() { (user) -> () in
                self.loadNextView(user)
            }
        }
    }
    
    func loadNextView(user: User?) {
        if let user = user {
            println("Login Success")
            println(user)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! ViewController
            home.setUserObject(user)
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            println("Login Failed")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
}