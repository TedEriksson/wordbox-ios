//
//  NetworkClient.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import Alamofire
import Realm

class NetworkClient {
    static let baseUrl = "https://wordbox.herokuapp.com"
    
    class func updateUser(id: Int, callback: (User)  -> ()) {
        setHeaderFields()
        Alamofire.request(.GET, "\(baseUrl)/users/\(id)")
            .responseJSON { (_, response, json, _) -> Void in
                self.updateHeaderFields(response!)
                
                let realm = RLMRealm.defaultRealm()
                
                realm.transactionWithBlock({ () -> Void in
                    let user = User.createOrUpdateInRealm(realm, withObject: json)
                    
                    callback(user)
                })
        }
    }
    
    class func loginUser(email: String, password: String, callback: (User?) -> ()) {
        let params = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, "\(baseUrl)/auth/sign_in", parameters: params)
            .validate()
            .responseJSON { (_, response, JSON, _) in
                if (response?.statusCode >= 400) {
                    callback(nil)
                    return
                }
                self.updateHeaderFields(response!)
                
                let realm = RLMRealm.defaultRealm()
                
                realm.transactionWithBlock({ () -> Void in
                    let user = User.createOrUpdateInRealm(realm, withObject: JSON?.valueForKey("data"))
                    
                    callback(user)
                })
            }
    }
    
    class func setHeaderFields() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Access-Token": defaults.objectForKey("access-token") as! String,
            "Uid": defaults.objectForKey("uid") as! String,
            "Token-Type": defaults.objectForKey("token-type") as! String,
            "Client": defaults.objectForKey("client") as! String,
            "Expiry": defaults.objectForKey("expiry") as! String
        ]
    }
    
    class func updateHeaderFields(response: NSHTTPURLResponse) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(response.allHeaderFields["Access-Token"], forKey: "access-token")
        defaults.setObject(response.allHeaderFields["Uid"], forKey: "uid")
        defaults.setObject(response.allHeaderFields["Token-Type"], forKey: "token-type")
        defaults.setObject(response.allHeaderFields["Client"], forKey: "client")
        defaults.setObject(response.allHeaderFields["Expiry"], forKey: "expiry")
    }
}