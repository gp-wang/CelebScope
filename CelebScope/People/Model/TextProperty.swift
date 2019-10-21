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


public class TextProperty {
    internal init(detectedLanguages: DetectedLanguage?, detectedBreak: DetectedBreak?) {
        self.detectedLanguages = detectedLanguages
        self.detectedBreak = detectedBreak
    }
    
    init?(json: [String: Any]) {
        if let detectedLanguages = json["detectedLanguages"] as? DetectedLanguage {
            self.detectedLanguages = detectedLanguages
        } else {
            self.detectedLanguages = nil
        }
        
        
        if let detectedBreak = json["detectedBreak"] as? DetectedBreak {
            self.detectedBreak = detectedBreak
        } else {
            self.detectedBreak = nil
        }
        
    }
    
    let detectedLanguages: DetectedLanguage?
    let detectedBreak: DetectedBreak?
}
