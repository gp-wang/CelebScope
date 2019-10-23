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


public struct BoundingPoly: Codable {
   
    
    let vertices: [Vertex]
    
}
