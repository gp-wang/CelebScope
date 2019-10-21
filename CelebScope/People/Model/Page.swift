//
//  Page.swift
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
 "width": number,
 "height": number,
 "blocks": [
 {
 object (Block)
 }
 ],
 "confidence": number
 }*/

import Foundation

public class Page {
    internal init(property: TextProperty, width: Int, height: Int, blocks: [Block]) {
        self.property = property
        self.width = width
        self.height = height
        self.blocks = blocks
    }
    
    init?(json: [String: Any]) {
        guard let property = json["property"] as? TextProperty,
            let width = json["width"] as? Int,
            let height = json["height"] as? Int,
            let blocks = json["blocks"] as? [Block]
        
        else {
                return nil
        }
        self.property = property
        self.width = width
        self.height = height
        self.blocks = blocks
        
    }
    
    let property: TextProperty
    let width: Int
    let height: Int
    let blocks: [Block]
    
}
