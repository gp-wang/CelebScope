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

public enum BlockType: String {
   case UNKNOWN //    Unknown block type.
   case TEXT //    Regular text block.
   case TABLE //    Table block.
   case PICTURE //    Image block.
   case RULER //    Horizontal/vertical line box.
   case BARCODE //    Barcode block.
}


public class Block {
    internal init(property: TextProperty?, boundingBox: BoundingPoly, paragraphs: [Paragraph], blockType: BlockType) {
        self.property = property
        self.boundingBox = boundingBox
        self.paragraphs = paragraphs
        self.blockType = blockType
    }
    
    init?(json: [String: Any]) {
        
        if let property = json["property"] as? TextProperty  {
            self.property = property
        } else {
            self.property = nil
        }
        
        guard let boundingBox = json["boundingBox"] as? BoundingPoly,
        let paragraphs = json["paragraphs"] as? [Paragraph]
        else {
            return nil
        }
        self.boundingBox = boundingBox
        self.paragraphs = paragraphs
        
        
        guard let blockTypeJson = json["blockType"] as? String, let blockType = BlockType(rawValue: blockTypeJson) else {
            return nil
        }
        
       self.blockType = blockType
    }
    
    let property: TextProperty?
    let boundingBox: BoundingPoly
    let paragraphs: [Paragraph]
    
    let blockType: BlockType
    
}
