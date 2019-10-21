//
//  Symbol.swift
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
 "text": string,
 "confidence": number
 }*/

import Foundation


public class Symbol {
    internal init(property: TextProperty?, boundingBox: BoundingPoly, text: String) {
        self.property = property
        self.boundingBox = boundingBox
        self.text = text
    }
    
    init?(json: [String: Any]) {
        if let property = json["property"] as? TextProperty {
            self.property = property
        } else {
            self.property = nil
        }
        
        
        guard let boundingBox = json["boundingBox"] as? BoundingPoly,
            let text = json["text"] as? String
            else {
                return nil
        }
        
        self.boundingBox = boundingBox
        self.text = text
        
    }
    
    let property: TextProperty?
    let boundingBox: BoundingPoly
    
    let text: String
}
