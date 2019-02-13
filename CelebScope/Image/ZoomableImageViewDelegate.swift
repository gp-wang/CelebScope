//
//  ZoomableImageViewDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/28/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
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
        // gw_log("scale factor is: \(scrollView.zoomScale)")
        return delegator.imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageView = delegator.imageView
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        guard let actionTaker = actionTaker else {return }
        //gw_log("scale factor is: \(scrollView.zoomScale)")
        // gw_log("from inside ZoomableImageViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let actionTaker = actionTaker else {return }
        //gw_log("content offset is: \(scrollView.contentOffset)")
        // gw_log("from inside ZoomableImageViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    
}
