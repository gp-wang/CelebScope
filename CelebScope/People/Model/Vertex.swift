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


public class Vertex {
    internal init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init?(json: [String: Any]) {
        
        guard let x = json["x"] as? Int,
            let y = json["y"] as? Int
            else {
                return nil
        }
        
        self.x = x
        self.y = y
        
    }
    
    let x: Int
    let y: Int
}
