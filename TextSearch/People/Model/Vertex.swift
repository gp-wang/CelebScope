//
//  Vertex.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "x": number,
 "y": number
 }*/
import Foundation


public class Vertex: Codable {
   
    
    let x: Int
    let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let x = try container.decodeIfPresent(Int.self, forKey: .x) {
            self.x = x
        } else {
            self.x = 0
        }
        
        if let y = try container.decodeIfPresent(Int.self, forKey: .y) {
                   self.y = y
               } else {
                   self.y = 0
               }
    }
}
