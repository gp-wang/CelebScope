//
//  ZoomableImageViewDelegate.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/28/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class ZoomableImageViewDelegate: NSObject, UIScrollViewDelegate {
   

    
    // store a reference to the object which will take the actual action
    weak var actionTaker: Canvas?
    
    // the delegator who relies on this object
    unowned let delegator: ZoomableImageView
    
    init(delegator: ZoomableImageView) {
        self.delegator = delegator
        super.init()
    }
    
    
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            // print("scale factor is: \(scrollView.zoomScale)")
            return delegator.imageView
        }
        
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let actionTaker = actionTaker else {return }
            print("scale factor is: \(scrollView.zoomScale)")
            // print("from inside ZoomableImageViewDelegate")
            actionTaker.updateAnnotation()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let actionTaker = actionTaker else {return }
        print("content offset is: \(scrollView.contentOffset)")
            // print("from inside ZoomableImageViewDelegate")
            actionTaker.updateAnnotation()
        }
    

}
