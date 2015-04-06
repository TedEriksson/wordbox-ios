
//
//  Word.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import Realm

class Word: RLMObject {
    dynamic var id = 0
    dynamic var text = ""
    dynamic var order = 0
    
    override class func primaryKey() -> String {
        return "id"
    }
}