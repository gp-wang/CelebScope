//
//  Canvas.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


class Canvas : UIView {
    
    
   
     public var pairs = [(CGPoint, CGPoint, Bool)] ()
    

    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for (startPoint, endPoint, isVertical) in pairs {
        
            let pathPoints = generateAnnotationPoints(startPoint, endPoint, isVertical)
            
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(7)
            
            for (idx, point) in pathPoints.enumerated() {
                if idx == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }

            context.strokePath()
        }
    }
    
    
}
