//
//  Word.swift
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
 "symbols": [
 {
 object (Symbol)
 }
 ],
 "confidence": number
 }*/
import Foundation


public struct Word: Codable {

    
    let property: TextProperty?
    let boundingBox: BoundingPoly
    let symbols: [ Symbol ]
    
    public var text: String {
        get {
            let symbolTextArray: [String] = symbols.map{ $0.text }
            let result: String = symbolTextArray.joined()
            return result
        }
    }
}