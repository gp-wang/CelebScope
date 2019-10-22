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


struct Symbol: Codable {
  
    let property: TextProperty?
    let boundingBox: BoundingPoly
    
    let text: String
}
