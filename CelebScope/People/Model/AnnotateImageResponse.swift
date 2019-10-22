//
//  AnnotateImageResponse.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation


struct GoogleCloudVisionApiResponses: Codable {
    let responses: [AnnotateImageResponse]
}

struct AnnotateImageResponse: Codable {
    
    
    let textAnnotations: [EntityAnnotation]
    
    let fullTextAnnotation: TextAnnotation
    
}
