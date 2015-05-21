//
//  Sentence.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import RealmSwift

class Sentence: Object {
    dynamic var id = 0
    dynamic var hearts = 0
    var words = List<Word>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func getWordsAsString() -> String {
        var sentence = ""
        for word in words {
            sentence += word.text + " "
        }
        
        return sentence.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}