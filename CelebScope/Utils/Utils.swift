//
//  Utils.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/22/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
import CoreGraphics
import Foundation

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
