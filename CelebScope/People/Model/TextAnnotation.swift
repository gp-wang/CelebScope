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


public class TextAnnotation {
    internal init(pages: [Page], text: String) {
        self.pages = pages
        self.text = text
    }
    
    init?(json: [String: Any]) {
        guard let pages = json["pages"] as? [Page],
            let text = json["text"] as? String   else {
                return nil
        }
        
        self.pages = pages
        self.text = text
        
        
    }
    
    let pages: [Page]
    let text: String
}
