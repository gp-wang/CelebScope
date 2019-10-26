//
//  ZoomableImageViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/25/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC for the photoView
class ZoomableImageViewController: UIViewController {

    let zoomableImageView  = ZoomableImageView()
    
    public init() {
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(zoomableImageView)
        
        setupInternalLayoutConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // double tap zoom: https://www.appcoda.com/uiscrollview-introduction/
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        zoomableImageView.addGestureRecognizer(doubleTap)
    }
    
    @objc
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (zoomableImageView.zoomScale > zoomableImageView.minimumZoomScale) {
            zoomableImageView.setZoomScale(zoomableImageView.minimumZoomScale, animated: true)
        } else {
            zoomableImageView.setZoomScale(zoomableImageView.maximumZoomScale, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()  // double tap zoom: https://www.appcoda.com/uiscrollview-introduction/
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        gw_log("gw: viewWillLayoutSubviews")
        
        
        // gw: main queue make it works now:
        // https://stackoverflow.com/questions/54452127/how-to-wait-for-subview-layout-settle-down-after-the-initial-viewdidload-cycle?noredirect=1#comment95712755_54452127
        DispatchQueue.main.async {
            self.zoomableImageView.setZoomScale()
        }
        
    }
    
    public func setImage(image: UIImage)  {
        
        // delegate the imageView to set the image content
        zoomableImageView.setImage(image: image)
        
        
        // https://stackoverflow.com/a/15141367/8328365
        // but delegate the layout update responsibility inside VC ('view' is VC's view), not view
        // gw: note, need to be placed at VC level 
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    
    private func setupInternalLayoutConstraints()  {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: zoomableImageView.topAnchor),
            view.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor),
            ])
    }
    
    // zoom to rect with specified ratio
    // gw: rect is in CG coord
    public func zoom(to rect: CGRect, animated: Bool) {
        
       zoomableImageView.zoom(to: rect, with: ZoomableImageView.Constants.contentSpanRatio, animated: animated)
    }
    
    // gw: boundingBox is in UI Coord

    public func zoom(to uiBoundingBox: BoundingPoly, animated: Bool) {
        // a intermediate CGRect for transition, it is in UICoord
        // TODO: // gw: here
        let dummyCGRectInUICoord: CGRect = CGRect(uiBoundingBox)
        let rectInCGCoord: CGRect = zoomableImageView.imageView.convertRect(fromImageRect: dummyCGRectInUICoord)
        zoom(to: rectInCGCoord,  animated: animated)
    }
}
