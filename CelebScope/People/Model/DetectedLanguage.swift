//
//  DetectedLanguage.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "languageCode": string,
 "confidence": number
 }
*/
import Foundation


public class DetectedLanguage {
    internal init(languageCode: String) {
        self.languageCode = languageCode
    }
    
    init?(json: [String: Any]) {
        guard let languageCode = json["languageCode"] as? String else {
            return nil
        }
        
         self.languageCode = languageCode
    }
    
    let languageCode: String
}
