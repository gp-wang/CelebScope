//
//  ZoomableImageViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        print("gw: viewWillLayoutSubviews")
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func setupInternalLayoutConstraints()  {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: zoomableImageView.topAnchor),
            view.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor),
            ])
    }
    
    // zoom to rect with specified ratio
    public func zoom(to rect: CGRect, animated: Bool) {
        
       zoomableImageView.zoom(to: rect, with: ZoomableImageView.Constants.contentSpanRatio, animated: animated)
    }
}
