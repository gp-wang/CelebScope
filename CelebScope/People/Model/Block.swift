//
//  Block.swift
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
 "paragraphs": [
 {
 object (Paragraph)
 }
 ],
 "blockType": enum (BlockType),
 "confidence": number
 }*/


import Foundation

public enum BlockType: String, Codable {
   case UNKNOWN //    Unknown block type.
   case TEXT //    Regular text block.
   case TABLE //    Table block.
   case PICTURE //    Image block.
   case RULER //    Horizontal/vertical line box.
   case BARCODE //    Barcode block.
}


struct Block: Codable {
   
    
    let property: TextProperty?
    let boundingBox: BoundingPoly
    let paragraphs: [Paragraph]
    
    let blockType: BlockType
    
}
