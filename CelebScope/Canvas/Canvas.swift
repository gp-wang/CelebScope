//
//  Canvas.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// A canvas's responsibility is to draw annotation for two delegators:
// 1. peopleCollectionView
// 2. zoomableImageView
// Therefore, it make sense to instantiate it after above two is instantiated
class Canvas : UIView {

    // dedicated two vars, because canvas has two delegate responsibilities, and both are scrollview delegate
    // strong ref
    var peopleCollectionViewDelegate: PeopleCollectionViewDelegate?
    var zoomableImageViewDelegate: ZoomableImageViewDelegate?
    
    // who delegates
    var peopleCollectionView: UICollectionView?
    var zoomableImageView: ZoomableImageView?
    
    // orientation, updated from viewController
    var isLandscape: Bool = true
    
    // 1st input stage: gets data from external
    public var identifications : [Identification]? {
        didSet {
            // process data and converts into drawing pairs
            // gw: need to wrap within main thread. (check out the other usages in scrollViewDidScroll, which is likely living in main thread
            DispatchQueue.main.async {
                self.updateAnnotation()
            }

        }
    }
    
    
    // 2nd input stage (take input from self.identifications)
    // gw: Input for draw method
    public var pairs = [(CGPoint, CGPoint)] ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//
//        let path = UIBezierPath(arcCenter: self.bounds.origin, radius: self.bounds.width, startAngle: 0, endAngle: .pi * 1.0, clockwise: true)
//        UIColor.green.setFill()
//        path.fill()
//
//        return
        
        // gw_log("inside draw")
        guard let context = UIGraphicsGetCurrentContext() else {
            NSLog("err: cannot get graphics context")
            return
            
        }
//
//        //context.setFillColor(UIColor.yellow.cgColor)
//        let aPath = UIBezierPath(arcCenter: CGPoint(x: 650, y: 700), radius: 300, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
//        //UIColor.red.setFill()
//
//
//        var bPath = aPath.reversing()
//        context.setFillColor(UIColor.yellow.cgColor)
//
////        bPath.fill()
////        bPath.stroke()
//
//        context.addPath(aPath.cgPath)
//        context.fillPath()
        

        for (startPoint, endPoint) in pairs {

            // note: if islandscape, means scroll direction is vertical
            let pathPoints = generateAnnotationPoints(startPoint, endPoint, self.isLandscape)

            
            // gw_log("generated points: \(pathPoints)")
            context.setStrokeColor(Colors.brightOrange.cgColor)
            context.setLineWidth(3)

            for (idx, point) in pathPoints.enumerated() {
                if idx == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }

            // context.addPath(aPath.cgPath)
            // context.fillPath()
            context.strokePath()


        }
    }
    
    // For passing touches from an overlay view to the views underneath,
    // https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //gw_log("Passing all touches to the next view (if any), in the view stack.")
        return false
    }
    
    
    
    
    public func updateAnnotation() {
        //TODO: need to check whether both ends are visible
        
        guard  let peopleCollectionView = peopleCollectionView,
            let zoomableImageView = zoomableImageView,
            let identifications = self.identifications,
            let collectionViewFlowLayout =  peopleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                NSLog("failed to unwrap peopleCollectionView zoomableImageView identifications  collectionViewFlowLayout")
                
                return
                
        }
        
        //DispatchQueue.main.async {
        
        
        
        self.pairs.removeAll()
        
        // gw: likely no need to place in dispatch main because at this calling time (scrollView did scroll), these frames are guaranteed to exist
        // gw: because scrolling changes visible cells, we need to do canvas.pairs update in this lifecycle as well
        
        for (i,cell) in peopleCollectionView.visibleCells.enumerated() {
            
            // assume only one section
            let index_in_all_cells = peopleCollectionView.indexPathsForVisibleItems[i].row
            
            
            // gw: working: when doing coord conversion, should each time convert CONSECUTIVELY related two views like below
            let startPoint_in_CGImage = identifications[index_in_all_cells].face.position
            let startPoint_in_UIImageView = zoomableImageView.imageView.convertPoint(fromImagePoint: startPoint_in_CGImage)
            let startPoint_in_ScrollView = zoomableImageView.imageView.convert(startPoint_in_UIImageView, to: zoomableImageView)
            // because UIImageView content mode is 1:1 here, we directly use it here
            // convert to point inside canvas (which 1:1 overlays on zoomableImageView
            let startPoint = zoomableImageView.convert(startPoint_in_ScrollView, to: self)

            
            // gw: note: NOT WORKING, when do coord conversion, should each time convert CONSECUTIVELY related two views (one step at a time, see above working example)
//            let startPoint_in_CGImage = identifications[index_in_all_cells].face.position
//            let startPoint_in_UIImageView = zoomableImageView.imageView.convertPoint(fromImagePoint: startPoint_in_CGImage)
//            let startPoint = zoomableImageView.convert(startPoint_in_UIImageView, to: self)
            
            
            var endPoint = peopleCollectionView.convert(cell.frame.origin, to: self)
            
            // translate by half the side length to point to middle point
            // flag for orientation determination
            if self.isLandscape {
                // -1 to ensure point still lies within bounds
                endPoint = endPoint.applying(CGAffineTransform(translationX: -1, y: cell.bounds.height / 2   ))
            } else {
                endPoint = endPoint.applying(CGAffineTransform(translationX: cell.bounds.width / 2 , y:  -1  ))
            }
            
            // if either endpoint not in canvas bounds, skip it
            if !(self.bounds.contains(startPoint) && self.bounds.contains(endPoint) ) {
                continue
            }
            
            
            self.pairs.append((startPoint, endPoint))
            //gw_log("pairs: \(self.pairs)")
        }
        
        self.setNeedsDisplay()
        //}
    }
    
 
    
}


// moved to dedicated class PeopleCollectionViewDelegate
//extension Canvas : UIScrollViewDelegate {
//    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
//    // here the scrollView is the people collection scrollview
//    // here the canvas is the overlaying annotation layer on top of photoView
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.updateAnnotation(scrollView: scrollView)
//    }
//
//
//
//}
