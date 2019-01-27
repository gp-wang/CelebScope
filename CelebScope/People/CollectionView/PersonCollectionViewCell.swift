//
//  PersonCollectionViewCell.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/23/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


//TODO: embed in paged VC for multiple prediction results
class PersonCollectionViewCell: UICollectionViewCell {
    
    private struct Constants {
        static let faceViewWHRatio : CGFloat = 1.0
        static let avartarViewWHRatio: CGFloat =  214.0 / 317.0
    }
    
    //
    let croppedFaceView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.backgroundColor = UIColor.green
        _imageView.contentMode = .scaleAspectFit
        return _imageView
    } ()
    
    let avartarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()
    
    
    let nameLabel : UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "Custome Label"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(15)
        _label.backgroundColor = UIColor.green
        
        return _label
    } ()
    
//    let extendedPredictionLabel: UILabel = {
//        let _label = UILabel()
//        _label.translatesAutoresizingMaskIntoConstraints = false
//        _label.backgroundColor = .green
//        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        _label.lineBreakMode = .byWordWrapping
//        _label.numberOfLines = 5
//        return _label
//    } ()
    
    let confidenceLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .green
        // _label.font = UIFont.preferredFont(forTextStyle: .headline)
       
     
        _label.font =   UIFont.preferredFont(forTextStyle: .headline).withSize(15)
        _label.text = "66%"
        return _label
    } ()
    
    // MARK: - constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(croppedFaceView)
        addSubview(nameLabel)
        addSubview(avartarView)
        addSubview(confidenceLabel)
        
        self.backgroundColor = UIColor.red
        
        setupInternalConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupInternalConstraints() {
        let views: [String: Any] = [
            "croppedFaceView": croppedFaceView,
            "avartarView": avartarView,
            "nameLabel": nameLabel,
            "confidenceLabel": confidenceLabel
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        
        // cell constraints is done in: extension CollectionViewController: UICollectionViewDelegateFlowLayout

        // croppedFaceView
        var croppedFaceView_V = [
            croppedFaceView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            croppedFaceView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
        ]
        var croppedFaceView_H = [
            croppedFaceView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            croppedFaceView.widthAnchor.constraint(equalTo: croppedFaceView.heightAnchor, multiplier: Constants.faceViewWHRatio)
        ]
        allConstraints += croppedFaceView_V
        allConstraints += croppedFaceView_H
        
        
        // confidenceLabel
        var confidenceLabel_H = [NSLayoutConstraint]()
        confidenceLabel_H += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[croppedFaceView]-[confidenceLabel]-[avartarView]",
            metrics: nil,
            //options: []
            views: views)
        
        var confidenceLabel_V = [
            confidenceLabel.centerYAnchor.constraint(equalTo: croppedFaceView.centerYAnchor)
        ]
        allConstraints += confidenceLabel_H
        allConstraints += confidenceLabel_V
        
        // avartarView
        var avartarView_H = [NSLayoutConstraint]()
        avartarView_H += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[avartarView]-|",
            metrics: nil,
            //options: []
            views: views)
        avartarView_H += [
            avartarView.widthAnchor.constraint(equalTo: avartarView.heightAnchor, multiplier: Constants.avartarViewWHRatio)
        ]

        var avartarView_V = [NSLayoutConstraint]()
        avartarView_V += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[avartarView]-|",
            metrics: nil,
            //options: []
            views: views)
        allConstraints += avartarView_H
        allConstraints += avartarView_V
        
        
        
        // nameLabel
        let nameLabel_V = NSLayoutConstraint.constraints(
            //withVisualFormat: "V:[croppedFaceView]-[nameLabel]-|",
            withVisualFormat: "V:[nameLabel]-|",
            metrics: nil,
            //options: []
            views: views)
        let nameLabel_H = [
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        allConstraints += nameLabel_V
        allConstraints += nameLabel_H


        
        
        NSLayoutConstraint.activate(allConstraints)
        
        
       
    }
    
}
