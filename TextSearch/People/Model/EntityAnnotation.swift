//
//  EntityAnnotation.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//


/*
 JSON representation
 {
 "mid": string,
 "locale": string,
 "description": string,
 "score": number,
 "confidence": number,
 "topicality": number,
 "boundingPoly": {
 object (BoundingPoly)
 },
 "locations": [
 {
 object (LocationInfo)
 }
 ],
 "properties": [
 {
 object (Property)
 }
 ]
 }
 
 */

import Foundation

public struct EntityAnnotation: Codable {
    
    
    
    let mid: String?
    let locale: String?
    let description: String?
    
    let boundingPoly: BoundingPoly
    
    let properties: [Property]?
    
    
    
}