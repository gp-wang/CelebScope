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
    let searchText: String
    let symbols: [Symbol]
    
    public init(searchText: String, symbols: [Symbol]) {
        self.searchText = searchText
        self.symbols = symbols
    }
}
