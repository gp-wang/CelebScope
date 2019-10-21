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


public class Word {
    internal init(property: TextProperty?, boundingBox: BoundingPoly, symbols: [Symbol]) {
        self.property = property
        self.boundingBox = boundingBox
        self.symbols = symbols
    }
    
    init?(json: [String: Any]) {
        if let property = json["property"] as? TextProperty {
            self.property = property
        } else {
            self.property = nil
        }
        
        
        guard let boundingBox = json["boundingBox"] as? BoundingPoly,
            let symbols = json["symbols"] as? [Symbol]
            else {
                return nil
        }
        
        self.boundingBox = boundingBox
        self.symbols = symbols
        
    }
    
    let property: TextProperty?
    let boundingBox: BoundingPoly
    let symbols: [ Symbol ]
}
