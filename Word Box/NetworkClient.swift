//
//  NetworkClient.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkClient {
    static let baseUrl = "https://wordbox.herokuapp.com"
    
    class func addFriend(id: Int, username: String, callback: (Bool) -> ()) {
        setHeaderFields()
        Alamofire.request(.POST, "\(baseUrl)/users/\(id)/add_friend/\(username)")
            .responseJSON { (_, response, _, _) -> Void in
                self.updateHeaderFields(response!)
                
                if (response!.statusCode == 200) {
                    println(response?.statusCode)
                    callback(true)
                    return
                }
                
                callback(false)
                return
        }
    }
    
    class func getRequests(id: Int, callback: (String?) -> ()) {
        setHeaderFields()
        Alamofire.request(.GET, "\(baseUrl)/users/\(id)/friend_requests")
            .responseJSON { (_, response, json, _) -> Void in
                self.updateHeaderFields(response!)
                
                if response?.statusCode == 200 {
                    println(json)
                    return
                }
                
                return
        }
    }
    
    class func updateUser(id: Int, callback: (User)  -> ()) {
        setHeaderFields()
        Alamofire.request(.GET, "\(baseUrl)/users/\(id)")
            .responseJSON { (_, response, json, _) -> Void in
                self.updateHeaderFields(response!)
                
                let realm = Realm()
                
                realm.write {
                    let user = realm.create(User.self, value: json!, update: true)
                    
                    callback(user)
                }
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
                
                let realm = Realm()
                
                realm.write {
                    let user = realm.create(User.self, value: JSON!.valueForKey("data")!, update: true)
                    
                    callback(user)
                }
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
                
                let realm = Realm()
                
                realm.write {
                    let user = realm.create(User.self, value: json!, update: true)
                    
                    callback(user)
                }
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
    
    class func createNewUser(email: String, username: String, password: String, callback: (User?, [String]?) -> ()) {
        let params = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, "\(baseUrl)/auth", parameters: params)
            .responseJSON { (_, response, JSON, _) in
                if (response?.statusCode >= 400) {
                    callback(nil, JSON?.valueForKey("errors")?.valueForKey("full_messages") as? [String])
                    return
                }
                self.updateHeaderFields(response!)
                
                let realm = Realm()
                
                realm.write {
                    let user = realm.create(User.self, value: JSON!.valueForKey("data")!, update: true)
                    
                    callback(user, nil)
                }
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
        }
    }
    
    class func updateHeaderFields(response: NSHTTPURLResponse) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let at: AnyObject = response.allHeaderFields["Access-Token"] {
            defaults.setObject(at, forKey: "access-token")
        }
        if let uid: AnyObject = response.allHeaderFields["Uid"] {
            defaults.setObject(uid, forKey: "uid")
        }
        if let tt: AnyObject = response.allHeaderFields["Token-Type"] {
            defaults.setObject(tt, forKey: "token-type")
        }
        if let c: AnyObject = response.allHeaderFields["Client"] {
            defaults.setObject(c, forKey: "client")
        }
        if let e: AnyObject = response.allHeaderFields["Expiry"] {
            defaults.setObject(e, forKey: "expiry")
        }
        defaults.synchronize()
    }
}