//
//  AlbumButton.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/29/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class AlbumButton: UIButton {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        //        let halfWidth: CGFloat = frame.width / 2.0
        //
        //        // make button round
        //        layer.cornerRadius = halfWidth
        //        layer.borderWidth = 3
        //        layer.borderColor = UIColor.white.cgColor
        // tintColor = UIColor.white
        
        
        let image = UIImage(imageLiteralResourceName: "album2") as UIImage?
        //self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        setImage(image, for: .normal)
        //imageView?.tintColor = UIColor.white
        
        //
        // addTarget(self, action: Selector("btnTouched:"), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
