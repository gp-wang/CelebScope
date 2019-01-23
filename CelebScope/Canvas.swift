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

        let path = UIBezierPath(arcCenter: self.bounds.origin, radius: self.bounds.width, startAngle: 0, endAngle: .pi * 1.0, clockwise: true)
        UIColor.green.setFill()
        path.fill()
        
        return
        
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        //context.setFillColor(UIColor.yellow.cgColor)
        let aPath = UIBezierPath(arcCenter: CGPoint(x: 650, y: 700), radius: 300, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
        //UIColor.red.setFill()
        
        
        var bPath = aPath.reversing()
        context.setFillColor(UIColor.yellow.cgColor)

//        bPath.fill()
//        bPath.stroke()
        
        context.addPath(aPath.cgPath)
        context.fillPath()
        
//
//        for (startPoint, endPoint, isVertical) in pairs {
//
//            let pathPoints = generateAnnotationPoints(startPoint, endPoint, isVertical)
//
//            context.setStrokeColor(UIColor.red.cgColor)
//            context.setLineWidth(7)
//
//            for (idx, point) in pathPoints.enumerated() {
//                if idx == 0 {
//                    context.move(to: point)
//                } else {
//                    context.addLine(to: point)
//                }
//            }
//
//            // context.addPath(aPath.cgPath)
//            // context.fillPath()
//            context.strokePath()
//
//
//        }
    }
    
    
}
