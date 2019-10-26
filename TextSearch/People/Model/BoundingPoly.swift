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
import CoreGraphics

// gw: in UI coord
public struct BoundingPoly: Codable {
   
    
    let vertices: [Vertex]
    
    
    
    
}



// gw: convenience methods

extension BoundingPoly {
    var xMin: Int {
        get {
            var _xMin : Int = Int.max
            for vertex in vertices {
                _xMin = min(_xMin, vertex.x)
                

            }
            
            return _xMin
        }
    }
    
    var xMax: Int {
        get {
            var _xMax : Int = Int.min
            for vertex in vertices {
                _xMax = max(_xMax, vertex.x)
                
                
            }
            
            return _xMax
        }
    }
    
   
    var yMin: Int {
        get {
            var yMin : Int = Int.max
            for vertex in vertices {
                yMin = min(yMin, vertex.y)
                
                
            }
            
            return yMin
        }
    }
    
    var yMax: Int {
        get {
            var yMax : Int = Int.min
            for vertex in vertices {
                yMax = max(yMax, vertex.y)
                
                
            }
            
            return yMax
        }
    }
    
    var position: CGPoint {
        get {
            return CGPoint(x: (xMax + xMin) / 2, y: (yMax + yMin) / 2 )
        }
    }
}

extension CGRect {
    
    // gw: the origin of rect is lower-left corner
    // https://developer.apple.com/documentation/coregraphics/cgrect
    init(_ boundingBox : BoundingPoly) {

        self.init(x: boundingBox.xMin, y: boundingBox.yMax, width: boundingBox.xMax - boundingBox.xMin, height: boundingBox.yMax - boundingBox.yMin)
    }
}
