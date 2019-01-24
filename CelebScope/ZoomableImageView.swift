//
//  ZoomableImageView.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/24/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit



class ZoomableImageView: UIScrollView {
    
    private struct Constants {
        static let minimumZoomScale: CGFloat = 0.5;
        static let  maximumZoomScale: CGFloat = 6.0;
    }
    
    
    // public so that delegate can access
    public let imageView = UIImageView()
    
    // gw: must be called to complete a setting
    public func setImage(image: UIImage) {
        imageView.image = image
        
        // gw: don't use bounds here.
        // TODO: think about why
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        self.contentSize = image.size
        
        
        let scaleFitZoomScale: CGFloat = min(
            self.frame.width / image.size.width ,
            self.frame.height / image.size.height
        )
        
        
        // reset scale and offset on each resetting of image
        self.zoomScale = scaleFitZoomScale
        
        
    }
    
    
    // MARK - constructor
    init() {
        // gw: there is no super.init(), you have to use this constructor as hack
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // gw: relies on autolayout constraint later
        
        minimumZoomScale = Constants.minimumZoomScale
        maximumZoomScale = Constants.maximumZoomScale
        
        addSubview(imageView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
