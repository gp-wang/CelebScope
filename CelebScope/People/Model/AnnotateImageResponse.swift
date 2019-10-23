//
//  AnnotateImageResponse.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation


public struct GoogleCloudVisionApiResponses: Codable {
    let responses: [AnnotateImageResponse]
}

public struct AnnotateImageResponse: Codable {
    
    
    let textAnnotations: [EntityAnnotation]
    
    let fullTextAnnotation: TextAnnotation
    
}
