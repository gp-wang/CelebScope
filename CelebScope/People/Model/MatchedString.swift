//
//  MatchIdentification.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/22/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

// a text_search match identification

import Foundation


public class MatchedString {
    
    // TODO: store some context here to be displayed in paged view or collection view
    
    let searchText: String
    // class invariant: symbols cannot be empty. (matched means at least one symbol)
    // we don't consider "" case
    let symbols: [Symbol]
    
    // gw: TODO, is there a way to calc once and store the result
    var boundingBox: BoundingPoly {
        get {
            var xMax : Int = Int.min
            var xMin: Int = Int.max
            var yMax: Int = Int.min
            var yMin: Int = Int.max
            
            for _symbol in symbols {
                xMax = max(xMax, _symbol.boundingBox.xMax)
                xMin = min(xMin, _symbol.boundingBox.xMin)
                yMax = max(yMax, _symbol.boundingBox.yMax)
                yMin = min(yMin, _symbol.boundingBox.yMin)
            }
            
            // gw: TODO ensure coord system is right (google API uses same coord direction as UIVIEW???)
            //    ans: likely yes, google (see the "engine" word position in the sample https://cloud.google.com/vision/docs/ocr )
            let topLeft = Vertex(x: xMin, y: yMin)
            let topRight = Vertex(x: xMax, y: yMin)
            let botLeft = Vertex(x: xMin, y: yMax)
            let botRight = Vertex(x: xMax, y: yMax)
            
            var vertices: [Vertex] = [topLeft, topRight, botRight, botLeft]
            return BoundingPoly(vertices: vertices)
        }
        
    }
    
    
    
    
    
    public init(searchText: String, symbols: [Symbol]) {
        self.searchText = searchText
        self.symbols = symbols
    }
}
