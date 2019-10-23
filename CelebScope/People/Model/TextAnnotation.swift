//
//  TextAnnotation.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "pages": [
 {
 object (Page)
 }
 ],
 "text": string
 }*/


import Foundation


public struct TextAnnotation: Codable {
    
    
    let pages: [Page]
    let text: String
}
