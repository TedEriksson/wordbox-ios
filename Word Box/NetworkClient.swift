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
    
    class func updateLoggedInUser(callback: (User?) -> ()) {
        setHeaderFields()
        Alamofire.request(.GET, "\(baseUrl)/users/me")
            .responseJSON { (_, response, json, _) -> Void in
                if (response?.statusCode >= 400) {
                    println(response?.statusCode)
                    callback(nil)
                    return
                }
                
                self.updateHeaderFields(response!)
                
                let realm = RLMRealm.defaultRealm()
                
                realm.transactionWithBlock({ () -> Void in
                    let user = User.createOrUpdateInRealm(realm, withObject: json)
                    
                    callback(user)
                })
        }

    }
    
    class func logOut(callback: (Bool) -> ()) {
        setHeaderFields()
        Alamofire.request(.DELETE, "\(baseUrl)/auth/sign_out")
            .responseJSON { (_, response, JSON, _) in
                self.updateHeaderFields(response!)
                callback(true)
        }
    }
    
    class func createSentence(words: [String], callback: (Bool) -> ()) {
        setHeaderFields()
        Alamofire.request(.POST, "\(baseUrl)/sentences", parameters: [ "words": words ])
            .responseJSON { (_, response, JSON, _) in
                self.updateHeaderFields(response!)
                if (response?.statusCode >= 400) {
                    callback(false)
                    return
                }
                callback(true)
            }
    }
    
    class func setHeaderFields() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let manager = Alamofire.Manager.sharedInstance
        let at = defaults.objectForKey("access-token") as? String
        let uid = defaults.objectForKey("uid") as? String
        let tt = defaults.objectForKey("token-type") as? String
        let c = defaults.objectForKey("client") as? String
        let e = defaults.objectForKey("expiry") as? String
        println(at)
        println(uid)
        println(tt)
        println(c)
        println(e)
        if let at = at, let uid = uid, let tt = tt, let c = c, let e = e {
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Access-Token": at,
                "Uid": uid,
                "Token-Type": tt,
                "Client": c,
                "Expiry": e
            ]
            println("headers: \(manager.session.configuration.HTTPAdditionalHeaders)")
        }
    }
    
    class func updateHeaderFields(response: NSHTTPURLResponse) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(response.allHeaderFields["Access-Token"], forKey: "access-token")
        defaults.setObject(response.allHeaderFields["Uid"], forKey: "uid")
        defaults.setObject(response.allHeaderFields["Token-Type"], forKey: "token-type")
        defaults.setObject(response.allHeaderFields["Client"], forKey: "client")
        defaults.setObject(response.allHeaderFields["Expiry"], forKey: "expiry")
        defaults.synchronize()
    }
}