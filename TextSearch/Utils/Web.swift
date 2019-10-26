//
//  Web.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/3/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//


import Foundation
import UIKit

// gw: for image identification
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


typealias ocrCompletionResponseHandler = (String, GoogleCloudVisionApiResponses) -> Void



// gw: moved fireOCRRequest and searchTextInImage to ViewController for easier access to VC's properties

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

/*
 sample body:
 
 {
 "requests": [
 {
 "image": {
 "content": "base64-encoded-image"
 },
 "features": [
 {
 "type": "TEXT_DETECTION"
 }
 ]
 }
 ]
 }
 */
func createOCRRequestBody(imageData: Data) throws -> Data  {
    
    //TODO: for testing
    //throw JsonDataError.runtimeError("Cannot convert image to jsonData in createOCRRequestBody")
    
    
    var messageDictionary : [String: Any] = [ "requests":
        [
            [
                "image":
                    ["content" : imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)],
                "features":
                    [
                        ["type": "DOCUMENT_TEXT_DETECTION"]
                    ]
            ],
        ]
    ]
     let jsonDataOpt = try? JSONSerialization.data(withJSONObject: messageDictionary, options: [])
    
    
    guard let jsonData = jsonDataOpt else {
        // fatalError("Cannot convert image to jsonData in createOCRRequestBody")
        throw JsonDataError.runtimeError("Cannot convert image to jsonData in createOCRRequestBody")
    }
    //let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
    //print (jsonString)

    
    
    return jsonData
}
