//
//  ZoomableImageViewDelegate.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/28/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class ZoomableImageViewDelegate: NSObject, UIScrollViewDelegate {
   

    let parentCanvas: Canvas
    let wrapperView: ZoomableImageView
    
    init(wapperView: ZoomableImageView, parentCanvas: Canvas) {
        self.wrapperView = wapperView
        self.parentCanvas = parentCanvas
        super.init()
    }
    
    
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            // print("scale factor is: \(scrollView.zoomScale)")
            return wrapperView.imageView
        }
        
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            print("scale factor is: \(scrollView.zoomScale)")
             print("from inside ZoomableImageViewDelegate")
            parentCanvas.updateAnnotation()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("content offset is: \(scrollView.contentOffset)")
             print("from inside ZoomableImageViewDelegate")
            parentCanvas.updateAnnotation()
        }
    

}
