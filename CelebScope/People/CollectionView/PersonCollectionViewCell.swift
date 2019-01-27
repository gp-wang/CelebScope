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
        _imageView.contentMode = .scaleAspectFit
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
        
        self.translatesAutoresizingMaskIntoConstraints = false
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
        
        
        // cell constraints is done in: extension CollectionViewController: UICollectionViewDelegateFlowLayout

        // croppedFaceView
        let croppedFaceView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[croppedFaceView]-|",
            metrics: nil,
            //options: []
            views: views)
        let croppedFaceView_H = [
            croppedFaceView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            croppedFaceView.widthAnchor.constraint(equalTo: croppedFaceView.heightAnchor)
        ]
        allConstraints += croppedFaceView_V
        allConstraints += croppedFaceView_H
        
        
        // nameLabel
        let nameLabel_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[nameLabel]",
            metrics: nil,
            //options: []
            views: views)
        let nameLabel_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[croppedFaceView]-10-[nameLabel]-|",
            metrics: nil,
            //options: []
            views: views)
        allConstraints += nameLabel_V
        allConstraints += nameLabel_H
        
        // extendedPrediction
        let extendedPredictionLabel_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[nameLabel]-[extendedPredictionLabel]",
            metrics: nil,
            //options: []
            views: views)
        let extendedPredictionLabel_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[croppedFaceView]-10-[extendedPredictionLabel]-|",
            metrics: nil,
            //options: []
            views: views)
        allConstraints += extendedPredictionLabel_V
        allConstraints += extendedPredictionLabel_H

        
        
        NSLayoutConstraint.activate(allConstraints)
        
        
       
    }
    
}
