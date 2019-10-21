//
//  BoundingPoly.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//


/*JSON representation
 {
 "vertices": [
 {
 object (Vertex)
 }
 ],
 "normalizedVertices": [
 {
 object (NormalizedVertex)
 }
 ]
 }*/

import Foundation


public class BoundingPoly {
    internal init(vertices: [Vertex]) {
        self.vertices = vertices
    }
    
    init?(json: [String: Any]) {
        guard let vertices = json["vertices"] as? [Vertex] else {
            return nil
        }
        
        self.vertices = vertices
    }
    
    let vertices: [Vertex]
    
}
