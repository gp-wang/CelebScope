//
//  MatchedSymbol.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/23/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation

public class MatchedSymbol {
    public init(symbol: String, boundingPoly: BoundingPoly) {
        self.symbol = symbol
        self.boundingPoly = boundingPoly
    }
    
    
    let symbol: String
    let boundingPoly: BoundingPoly
    
    
}
