//
//  PersonCollectionViewCell.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/23/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    let croppedFaceView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.backgroundColor = UIColor.green
        
        return _imageView
    } ()
    
    
    let nameLabel : UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "Custome Label"
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        _label.backgroundColor = UIColor.green
        
        return _label
    } ()
    
    let extendedPredictionLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .green
        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 5
        return _label
    } ()
    
    
    // MARK: - constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(croppedFaceView)
        addSubview(nameLabel)
        addSubview(extendedPredictionLabel)
        
        self.backgroundColor = UIColor.red
        
        setupInternalConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInternalConstraints() {
        let views: [String: Any] = [
            "croppedFaceView": croppedFaceView,
            "nameLabel": nameLabel,
            "extendedPredictionLabel": extendedPredictionLabel
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        
//        allConstraints += [
//            // cropped Face View
//            croppedFaceView.topAnchor.
//
//        ]
        
//        let labelHorizontalConstrains = NSLayoutConstraint.constraints(
//            withVisualFormat: "H:[avartarView]-20-[nameLabel]-15-[birthDeathDateLabel]-20-|",
//            metrics: nil,
//            //options: []
//            views: views)
//        allConstraints += labelHorizontalConstrains
        
        
        NSLayoutConstraint.activate(allConstraints)
        
//        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.333)
    }
    
}
