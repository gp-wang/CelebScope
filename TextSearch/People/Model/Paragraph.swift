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


public struct Paragraph: Codable {
    
    let property: TextProperty?
    
    let boundingBox: BoundingPoly
    
    let words: [Word]
    
    var text: String {
        get {
            let wordTextArray: [String] = words.map{ $0.text }
            // TODO: later // if language is CN, no separator
            return wordTextArray.joined(separator: " ")
        }
    }
}