//
//  Canvas.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

// gw: inherit UIImageView instead of UIView to use convenience method of converting point
// gw: anyway, this canvas's whole purpose is to overlaying and labeling for the UIImageView (photoView) beneath it
class Canvas : UIImageView {


    // gw: Input for face locations
    var faceLocationsInCgImage : [CGPoint] = [
        
        CGPoint(x: 100, y: 100),
        CGPoint(x: 700, y: 100),
        CGPoint(x: 1100, y: 100),
        
        CGPoint(x: 100, y: 650),
        CGPoint(x: 700, y: 650),
        CGPoint(x: 1100, y: 650),
        
        CGPoint(x: 100, y: 1400),
        CGPoint(x: 700, y: 1400),
        CGPoint(x: 1100, y: 1400),
        
        ]
    
    // gw: Input for draw method
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
    
    // For passing touches from an overlay view to the views underneath,
    // https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("Passing all touches to the next view (if any), in the view stack.")
        return false
    }
    
    
    
 
    
}

extension Canvas : UIScrollViewDelegate {
    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
    // here the scrollView is the people collection scrollview
    // here the canvas is the overlaying annotation layer on top of photoView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateAnnotation(scrollView: scrollView)
    }
    
    private func updateAnnotation(scrollView: UIScrollView) {
        //TODO: need to check whether both ends are visible
        guard let collectionView = scrollView as? UICollectionView,
            let collectionViewFlowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                NSLog("failed to convert scrollView to collectionView or layout as flow layout")
                
                return
                
        }
        //                guard let isVerticalScroll = self.isVerticalScroll else {
        //                    print("should have a scrool direction")
        //                    return
        //                }
        
        DispatchQueue.main.async {
            
            let isVerticalScroll = collectionViewFlowLayout.scrollDirection == .vertical
            
            self.pairs.removeAll()
            
            // gw: likely no need to place in dispatch main because at this calling time (scrollView did scroll), these frames are guaranteed to exist
            // gw: because scrolling changes visible cells, we need to do canvas.pairs update in this lifecycle as well
            
            for (i,cell) in collectionView.visibleCells.enumerated() {
                
                // assume only one section
                let index_in_all_cells = collectionView.indexPathsForVisibleItems[i].row
                let startPoint = self.convertPoint(fromImagePoint:  self.faceLocationsInCgImage[index_in_all_cells])
                
                var endPoint = collectionView.convert(cell.frame.origin, to: self)
                
                // translate by half the side length to point to middle point
                // flag for orientation determination
                if isVerticalScroll {
                    // -1 to ensure point still lies within bounds
                    endPoint = endPoint.applying(CGAffineTransform(translationX: -1, y: cell.bounds.height / 2   ))
                } else {
                    endPoint = endPoint.applying(CGAffineTransform(translationX: cell.bounds.width / 2 , y:  -1  ))
                }
                
                // if endpoint not in canvas bounds, skip it
                if !(self.bounds.contains(endPoint)) {
                    continue
                }
                
                // whether the annotation line is going to span horizontally
                let spanHorizontally : Bool = isVerticalScroll
                
                self.pairs.append((startPoint, endPoint, spanHorizontally))
                
            }
            
            self.setNeedsDisplay()
        }
    }
}
