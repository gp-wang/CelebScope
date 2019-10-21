//
//  AnnotateImageResponse.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation


public class AnnotateImageResponse {
    internal init(textAnnotations: EntityAnnotation, fullTextAnnotation: TextAnnotation) {
        self.textAnnotations = textAnnotations
        self.fullTextAnnotation = fullTextAnnotation
    }
    
    init?(json: [String: Any]) {
        guard let textAnnotations = json["textAnnotations"] as? EntityAnnotation,
            let fullTextAnnotation = json["fullTextAnnotation"] as? TextAnnotation else {
                return nil
        }
        
        self.textAnnotations = textAnnotations
        self.fullTextAnnotation = fullTextAnnotation
    }
    
    let textAnnotations: EntityAnnotation
    
    let fullTextAnnotation: TextAnnotation
    
}
