//
//  User.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var username = ""
    var friends = List<User>()
    var sentences = List<Sentence>()
    
    override class func primaryKey() -> String {
        return "id"
    }
}