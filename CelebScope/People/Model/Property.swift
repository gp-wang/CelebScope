//
//  Property.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

/*JSON representation
 {
 "name": string,
 "value": string,
 "uint64Value": string
 }*/

import Foundation

public class Property {
    internal init(name: String, value: String, uint64Value: String?) {
        self.name = name
        self.value = value
        self.uint64Value = uint64Value
    }
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
        let value = json["value"] as? String   else {
            return nil
        }
        
        self.name = name
        self.value = value
        
        if let uint64Value = json["uint64Value"] as? String  {
            self.uint64Value = uint64Value
        } else {
            self.uint64Value = nil
        }
    }
    
    
    
    let name: String
    
    let value: String
    
    let uint64Value: String?
}
