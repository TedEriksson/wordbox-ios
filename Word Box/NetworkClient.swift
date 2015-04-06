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
    
    class func updateUser(id: Int) {
        Alamofire.request(.GET, "\(baseUrl)/users/\(id)")
            .responseJSON { (_, _, json, _) -> Void in
                let realm = RLMRealm.defaultRealm()
                
                realm.transactionWithBlock({ () -> Void in
                    User.createOrUpdateInRealm(realm, withObject: json)
                })
                
                println("Updated User \(id)")
                println(User.allObjects())
        }
    }
}