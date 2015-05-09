//
//  Sentence.swift
//  Word Box
//
//  Created by Ted Eriksson on 06/04/2015.
//  Copyright (c) 2015 Vism. All rights reserved.
//

import Foundation
import Realm

class Sentence: RLMObject {
    dynamic var id = 0
    dynamic var hearts = 0
    dynamic var words = RLMArray(objectClassName: Word.className())
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func getWordsAsString() -> String {
        var sentence = ""
        for word in words {
            let word = word as! Word
            sentence += word.text + " "
        }
        
        return sentence.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}