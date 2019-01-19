//
//  Canvas.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


class Canvas : UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x:100  , y: 100)
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(7)
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        
        context.strokePath()
    }
    
    
}
