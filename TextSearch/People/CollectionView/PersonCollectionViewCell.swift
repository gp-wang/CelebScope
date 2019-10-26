//
//  PersonCollectionViewCell.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/23/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


//TODO: embed in paged VC for multiple prediction results
class PersonCollectionViewCell: UICollectionViewCell {
    
    private struct Constants {
        static let faceViewWHRatio : CGFloat = 1.0
        static let avartarViewWHRatio: CGFloat =  214.0 / 317.0
        static let textColor: UIColor = .white
    }
    
    
    // style for control line spacing
    static let nameLabelParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        //        paragraphStyle.paragraphSpacing = 0
        //        paragraphStyle.paragraphSpacingBefore = 0
        //        paragraphStyle.minimumLineHeight = 0
        //        paragraphStyle.headIndent = 0
        //        paragraphStyle.tailIndent = 0
        
        // https://stackoverflow.com/a/44658641/8328365
        paragraphStyle.lineHeightMultiple = 0.5  // this is the key of line spacing
        
        
        return paragraphStyle
    } ()
    
    var matchedString: MatchedString? {
        didSet {
            guard let _matchedString = self.matchedString else {
                gw_log("error: matchedString unwrap failed at setter")
                return
              
            }
            
            // update context text
            let attrString = NSMutableAttributedString(string: _matchedString.context)
            attrString.addAttribute(.paragraphStyle, value: PersonCollectionViewCell.nameLabelParagraphStyle, range:NSMakeRange(0, attrString.length))
            
            //self.nameLabel.text = _identification.person.name
            self.nameLabel.attributedText = attrString
        }
    }
    
//    var identification: Identification? {
//        didSet {
//            guard let _identification = self.identification else {
//                gw_log("error: unwrap failed at setter")
//                return
//
//            }
//
//            self.croppedFaceView.image = UIImage(cgImage: _identification.face.image)
//
//            // avartar and confidence display logic should be grouped together, either valid photo + prob, or unknown photo + 0%
//            if let _avartar = _identification.person.avartar, let _confidence = _identification.confidence as? Double {
//
//
//                self.avartarView.image = _avartar
//                // format to percent
//                self.confidenceLabel.text = String(format: "%.0f%%", _confidence * 100.0)
//            } else {
//                self.avartarView.image = UIImage(imageLiteralResourceName: "unknown")
//
//                self.confidenceLabel.text = "0%"
//            }
//
//            let attrString = NSMutableAttributedString(string: _identification.person.name)
//            attrString.addAttribute(.paragraphStyle, value: PersonCollectionViewCell.nameLabelParagraphStyle, range:NSMakeRange(0, attrString.length))
//
//            //self.nameLabel.text = _identification.person.name
//            self.nameLabel.attributedText = attrString
//
//
//        }
//    }
    
    //
//    let croppedFaceView: UIImageView = {
//        let _imageView = UIImageView()
//        _imageView.translatesAutoresizingMaskIntoConstraints = false
//        //_imageView.backgroundColor = UIColor.green
//        _imageView.backgroundColor = UIColor.clear
//        _imageView.contentMode = .scaleAspectFit
//        //_imageView.image = UIImage(imageLiteralResourceName: "mary")
//        return _imageView
//    } ()
//
//    let avartarView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .clear
//        imageView.contentMode = .scaleAspectFit
//        //imageView.image = UIImage(imageLiteralResourceName: "jlaw")
//        return imageView
//    } ()
//
//    // gw: wrapper to center nameLabel
//    let nameLabelWrapperView : UIView = {
//        let _view = UIView()
//        _view.translatesAutoresizingMaskIntoConstraints = false
//        //_view.backgroundColor = .red
//        _view.backgroundColor = .clear
//        return _view
//    } ()
    
    
    let nameLabel : UILabel = {
      
        let attrString = NSMutableAttributedString(string: "")
        attrString.addAttribute(.paragraphStyle, value: nameLabelParagraphStyle, range:NSMakeRange(0, attrString.length))

        let _label = UILabel()
        

        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.text = "Jeniffer Lawrence"
        _label.attributedText = attrString  // for controling line spacing
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(14)
        //_label.backgroundColor = UIColor.green
        _label.backgroundColor = UIColor.clear
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        _label.textColor = Constants.textColor
        //_label.backgroundColor = .red
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
    
//    let confidenceLabel: UILabel = {
//        let _label = UILabel()
//        _label.translatesAutoresizingMaskIntoConstraints = false
//        _label.backgroundColor = .clear
//        // _label.font = UIFont.preferredFont(forTextStyle: .headline)
//
//
//        _label.font =   UIFont.preferredFont(forTextStyle: .headline).withSize(19)
//        _label.text = "0%"
//        _label.adjustsFontSizeToFitWidth = true
//        _label.textColor = Constants.textColor
//        return _label
//    } ()
    
    // MARK: - constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(croppedFaceView)
//        addSubview(nameLabelWrapperView)
//        nameLabelWrapperView.addSubview(nameLabel)
//        addSubview(avartarView)
//        addSubview(confidenceLabel)
        
        addSubview(nameLabel)
        
        // self.backgroundColor = UIColor(red: CGFloat(15.0/255), green: CGFloat(163.0/255), blue: CGFloat(241.0/255), alpha: 1)
        self.backgroundColor = Colors.blue
        
//        DispatchQueue.main.async {
//            self.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
//        }
        
        
        setupInternalConstraints()
    }
    
    
    // for adding gradient for autolayout
    // https://stackoverflow.com/a/39591959/8328365
    private let gradient : CAGradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [Colors.green.cgColor, Colors.blue.cgColor]
        self.gradient.startPoint = CGPoint.init(x: 1, y: 1)
        self.gradient.endPoint = CGPoint.init(x: 0, y: 0)
        if self.gradient.superlayer == nil {
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }

//    override public func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
//
//    }
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        self.layer
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupInternalConstraints() {
        
        
        NSLayoutConstraint.activate([
            //nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            //nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  5),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            
            ])
        
        
       
    }
    
}