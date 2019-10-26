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

public struct Property: Codable {
    
    
    
    let name: String
    
    let value: String
    
    let uint64Value: String?
}
