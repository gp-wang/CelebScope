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


public struct DetectedLanguage: Codable {
   
    
    let languageCode: String
}
