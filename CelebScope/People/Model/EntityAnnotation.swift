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

public class EntityAnnotation {
    internal init(mid: String, locale: String, description: String, boundingPoly: BoundingPoly, properties: [Property]) {
        self.mid = mid
        self.locale = locale
        self.description = description
        self.boundingPoly = boundingPoly
        self.properties = properties
    }
    
    init?(json: [String: Any]) {
        guard let mid = json["mid"] as? String,
            let locale = json["locale"] as? String,
            let description = json["description"] as? String,
            let boundingPoly = json["boundingPoly"] as? BoundingPoly,
            //let propertiesJson = json["properties"] as? [String] // gw: per https://developer.apple.com/swift/blog/?id=37
            let properties = json["properties"] as? [Property]
        else {
                return nil
        }
        
//        var properties: Set<Property> = []
//        for string in propertiesJson {
//            guard let property = Property
//        }
        
        self.mid = mid
        self.locale = locale
        self.description = description
        self.boundingPoly = boundingPoly
        self.properties = properties
    }
    
    
    let mid: String
    let locale: String
    let description: String
    
    let boundingPoly: BoundingPoly
    
    let properties: [Property]
    
    
    
}
