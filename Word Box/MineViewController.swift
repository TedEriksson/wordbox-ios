//
//  MineViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import UIKit

class MineViewController: UIViewController {
    var parent: ViewController?
    
    func setViewController(vc: ViewController) {
        parent = vc
    }
    
    @IBAction func logOut(sender: AnyObject) {
        NetworkClient.logOut { (success) -> () in
            self.parent?.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}