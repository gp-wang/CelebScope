//
//  DetectedBreak.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "type": enum (BreakType),
 "isPrefix": boolean
 }*/
import Foundation


/*Enums
 UNKNOWN    Unknown break label type.
 SPACE    Regular space.
 SURE_SPACE    Sure space (very wide).
 EOL_SURE_SPACE    Line-wrapping break.
 HYPHEN    End-line hyphen that is not present in text; does not co-occur with SPACE, LEADER_SPACE, or LINE_BREAK.
 LINE_BREAK    Line break that ends a paragraph.*/
public enum BreakType: String {
    case UNKNOWN //    Unknown break label type.
    case SPACE //    Regular space.
    case SURE_SPACE //    Sure space (very wide).
    case EOL_SURE_SPACE //    Line-wrapping break.
    case HYPHEN //    End-line hyphen that is not present in text; does not co-occur with SPACE, LEADER_SPACE, or LINE_BREAK.
    case LINE_BREAK //    Line break that ends a paragraph.
    
}


public class DetectedBreak {
    internal init(type: BreakType, isPrefix: Bool?) {
        self.type = type
        self.isPrefix = isPrefix
    }

    init?(json: [String: Any]) {
        guard let typeJson = json["type"] as? String, let type = BreakType(rawValue: typeJson) else {
                return nil
        }
        
        self.type = type
        if let isPrefix = json["isPrefix"] as? Bool  {
            self.isPrefix = isPrefix
        } else {
            self.isPrefix = nil
        }
    }
    
    
    let type: BreakType
    let isPrefix: Bool?
}
