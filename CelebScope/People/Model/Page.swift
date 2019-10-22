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

struct Page: Codable {
  
    let property: TextProperty
    let width: Int
    let height: Int
    let blocks: [Block]
    
}
