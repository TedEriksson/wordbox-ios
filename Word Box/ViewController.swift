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

class ViewController: UIViewController, CAPSPageMenuDelegate {
    var pageMenu: CAPSPageMenu?
    
    var user: User?
    
    var friends: FriendsViewController!
    var boxes: BoxesViewController!
    var mine: MineViewController!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func showCreate(sender: UIButton) {
        var create = storyboard!.instantiateViewControllerWithIdentifier("CreateSentenceViewController") as! CreateSentenceViewController
        self.presentViewController(create, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var controllerArray = [UIViewController]()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        boxes = storyboard.instantiateViewControllerWithIdentifier("BoxesViewController") as! BoxesViewController
        boxes.title = "BOXES"
        boxes.setViewController(self)
        controllerArray.append(boxes)
        
        friends = storyboard.instantiateViewControllerWithIdentifier("FriendsViewController") as! FriendsViewController
        friends.title = "FRIENDS"
        friends.setViewController(self)
        controllerArray.append(friends)

        mine = storyboard.instantiateViewControllerWithIdentifier("MineViewController") as! MineViewController
        mine.title = "MINE"
        mine.setViewController(self)
        controllerArray.append(mine)
        
        var parameters: [String: AnyObject] = [
            "bottomMenuHairlineColor": UIColor(red: 0, green: 0, blue: 0, alpha: 0),
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
            "menuItemSeparatorPercentageHeight": 0.1,
            "scrollAnimationDurationOnMenuItemTap": 170]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 20.0, self.view.frame.width, self.view.frame.height), options: parameters)
        
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        self.view.backgroundColor = UIColor(red: 24.0/255.0, green: 120.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
        self.view.bringSubviewToFront(addButton)
    }
    
    func setUserObject(user: User) {
        self.user = user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

