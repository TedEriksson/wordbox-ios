//
//  ViewController.swift
//  Word Box
//
//  Created by Ted Eriksson on 05/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import UIKit
import Alamofire
import Realm

class ViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NetworkClient.updateUser(1)
        
        var controllerArray = [UIViewController]()
        
        var boxes = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BoxesViewController") as! UIViewController
        boxes.title = "BOXES"
        controllerArray.append(boxes)
        
        var friends = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FriendsViewController") as! UIViewController
        friends.title = "FRIENDS"
        controllerArray.append(friends)
        
        var mine = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MineViewController") as! UIViewController
        mine.title = "MINE"
        controllerArray.append(mine)
        
        var parameters: [String: AnyObject] = [
            "scrollMenuBackgroundColor": UIColor(red: 24.0/255.0, green: 120.0/255.0, blue: 200.0/255.0, alpha: 1.0),
            "selectionIndicatorColor": UIColor(red: 250.0/255.0, green: 111.0/255.0, blue: 0.0/255.0, alpha: 1.0),
            "menuMargin": 20.0,
            "menuHeight": 60.0,
            "menuItemSeparatorColor": UIColor(red: 0, green: 0, blue: 0, alpha: 0),
            "selectedMenuItemLabelColor": UIColor(red: 1, green: 1, blue: 1, alpha: 1.0),
            "unselectedMenuItemLabelColor": UIColor(red: 1, green: 1, blue: 1, alpha: 0.7),
            "menuItemFont": UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
            "useMenuLikeSegmentedControl": true,
            "selectionIndicatorHeight": 2.0,
            "menuItemSeparatorPercentageHeight": 0.1]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 20.0, self.view.frame.width, self.view.frame.height), options: parameters)
        
        self.view.addSubview(pageMenu!.view)
        self.view.backgroundColor = UIColor(red: 24.0/255.0, green: 120.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
        self.view.bringSubviewToFront(addButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

