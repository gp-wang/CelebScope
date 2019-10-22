//
//  TextProperty.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/21/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
/*JSON representation
 {
 "detectedLanguages": [
 {
 object (DetectedLanguage)
 }
 ],
 "detectedBreak": {
 object (DetectedBreak)
 }
 }*/
import Foundation


struct TextProperty : Codable{
    
    let detectedLanguages: [DetectedLanguage]?
    let detectedBreak: DetectedBreak?
}
