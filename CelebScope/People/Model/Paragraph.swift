//
//  Paragraph.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "property": {
 object (TextProperty)
 },
 "boundingBox": {
 object (BoundingPoly)
 },
 "words": [
 {
 object (Word)
 }
 ],
 "confidence": number
 }*/


import Foundation


public class Paragraph {
    internal init(property: TextProperty?, boundingBox: BoundingPoly, words: [Word]) {
        self.property = property
        self.boundingBox = boundingBox
        self.words = words
    }
    
    init?(json: [String: Any]) {
        if let property = json["property"] as? TextProperty {
            self.property = property
        } else {
            self.property = nil
        }
        
        
        guard let boundingBox = json["boundingBox"] as? BoundingPoly,
            let words = json["words"] as? [Word]
            else {
                return nil
        }
        
        self.boundingBox = boundingBox
        self.words = words
        
    }
    
    let property: TextProperty?
    
    let boundingBox: BoundingPoly
    
    let words: [Word]
}
