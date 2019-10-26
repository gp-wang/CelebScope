//
//  Utils.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/22/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//
import CoreGraphics
import Foundation
import UIKit

enum JsonDataError: Error {
    case runtimeError(String)
}

// generate an data structure to be used for drawing annotation line from face location in PhotoView to People Table view cell
func generateAnnotationPoints(_ beginPosition: CGPoint, _ endPosition: CGPoint, _ spanHoriozntally : Bool) -> [CGPoint] {
    
    if (spanHoriozntally) {
        
        // x, y of the turning point
        let y_turn = endPosition.y
        let x_turn = min(endPosition.x,
                         
                         beginPosition.x + abs(endPosition.y - beginPosition.y)
            
        )
        
        return [beginPosition
            , CGPoint(x: x_turn, y: y_turn)
            , endPosition
            
        ]
    } else {
        // x, y of the turning point
        let x_turn = endPosition.x
        let y_turn = min(endPosition.y,
                         
                         beginPosition.y + abs(endPosition.x - beginPosition.x)
            
        )
        
        return [beginPosition
            , CGPoint(x: x_turn, y: y_turn)
            , endPosition
            
        ]
    }
}

public class Utils {
    static let yearFormatter : DateFormatter = {
        
        let _formatter = DateFormatter()
        _formatter.dateFormat = "yyyy"
        return _formatter
    } ()
        
        
  

}


// MARK:  for encoding decoding image to string
// https://stackoverflow.com/a/46309421/8328365
func imageTobase64(image: UIImage) -> String {
    var base64String = ""
    
    
    if let imageData = image.jpegData(compressionQuality: 1){
        base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }

    return base64String
}

func base64ToImage(base64: String) -> UIImage {
    var img: UIImage = UIImage()
    if (!base64.isEmpty) {
        if let decodedData = Data(base64Encoded: base64 , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) as? Data {
            let decodedimage = UIImage(data: decodedData)
            img = (decodedimage as UIImage?)!
        }
        
    }
    return img
}
