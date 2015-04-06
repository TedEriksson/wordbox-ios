//
//  User.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import Realm

class User: RLMObject {
    dynamic var id = 0
    dynamic var username = ""
    dynamic var friends = RLMArray(objectClassName: User.className())
    dynamic var sentences = RLMArray(objectClassName: Sentence.className())
    
    override class func primaryKey() -> String {
        return "id"
    }
}