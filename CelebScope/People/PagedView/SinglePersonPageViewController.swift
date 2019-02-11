//
//  ViewController.swift
//  pageViewBlog
//
//  Created by Paul Tangen on 1/26/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit


class SinglePersonPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private struct Constants {

        static let textColor: UIColor = .white
        
        // gw: +40.0 for the copyright label
        static let avartarContainerViewWHRatio: CGFloat = 214.0 / (317.0 + 30.0)  // default avartar ratio in imdb celeb page
        // the ratio for the image only
        static let avartarImageWHRatio: CGFloat = 214.0 / (317.0)
        
        static let avartarImageSubviewTag: Int = 100
        static let avartarCopyrightSubviewTag: Int = 200
    }
    
    
    // style for control line spacing
    static let bioLabelParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        //        paragraphStyle.paragraphSpacing = 0
        //        paragraphStyle.paragraphSpacingBefore = 0
        //        paragraphStyle.minimumLineHeight = 0
        //        paragraphStyle.headIndent = 0
        //        paragraphStyle.tailIndent = 0
        //paragraphStyle.allowsDefaultTighteningForTruncation = true
        //paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        // https://stackoverflow.com/a/44658641/8328365
        paragraphStyle.lineHeightMultiple = 0.5  // this is the key of line spacing
        //paragraphStyle.headIndent = 0
        //paragraphStyle.firstLineHeadIndent = 0
        
        
        
        return paragraphStyle
    } ()
    
    let identification: Identification
//    let labelInst = UILabel()
    
    let avartarView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        // set tag for get back later
        imageView.tag = Constants.avartarImageSubviewTag  // https://stackoverflow.com/a/28200007/8328365
        
        let copyrightLabelView = UILabel()
        copyrightLabelView.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabelView.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(10)
        copyrightLabelView.textColor = .black
        copyrightLabelView.textAlignment = .center
        copyrightLabelView.backgroundColor = .white
        copyrightLabelView.text = "© Wikipedia"
        copyrightLabelView.tag = Constants.avartarCopyrightSubviewTag
        
        containerView.addSubview(imageView)
        containerView.addSubview(copyrightLabelView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: Constants.avartarImageWHRatio),
            
            
            
            copyrightLabelView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            copyrightLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            copyrightLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            copyrightLabelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
            
            ])
        
        
        
        return containerView
    } ()
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        _label.textColor = Constants.textColor
        return _label
    } ()
    
    let professionLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .subheadline)
         _label.textColor = Constants.textColor
        return _label
    } ()
    
    let bioLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .body)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 4
        _label.allowsDefaultTighteningForTruncation = true
        //_label.adjustsFontSizeToFitWidth = true
//
//        _label.isUserInteractionEnabled = true
        
        _label.textAlignment = .left
         _label.textColor = Constants.textColor
        let attrString = NSMutableAttributedString(string: "...")
        attrString.addAttribute(.paragraphStyle, value: bioLabelParagraphStyle, range:NSMakeRange(0, attrString.length))

        _label.attributedText = attrString
        
        // vertical align
        // https://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel
        //_label.sizeToFit()
        
        return _label
    } ()
    
    let birthDeathDateLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
        _label.textAlignment = .right   // first line,
         _label.textColor = Constants.textColor
        return _label
    } ()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
    }
    
    
    init(_ faceIdentification: Identification) {
        
        self.identification = faceIdentification
        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        
            
        if let avartarImageView = avartarView.viewWithTag(Constants.avartarImageSubviewTag) as? UIImageView {
            avartarImageView.image = faceIdentification.person.avartar?.copy() as? UIImage
        }
        
        nameLabel.text = faceIdentification.person.name
        
        professionLabel.text = faceIdentification.person.profession
        
        
        var bioStr : String
        if let rawBioStr = faceIdentification.person.bio {
            bioStr = rawBioStr.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } else {
            bioStr = "Not Available ..."
        }
        
        let attrString = NSMutableAttributedString(string: bioStr)
        attrString.addAttribute(.paragraphStyle, value: SinglePersonPageViewController.bioLabelParagraphStyle, range:NSMakeRange(0, attrString.length))
        
        
        bioLabel.attributedText = attrString
        // vertical align
        // https://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel
        // bioLabel.sizeToFit()
        
        var birthDeathDateStr = ""
        if let _birthDate = faceIdentification.person.birthDate {
            birthDeathDateStr = _birthDate + " - "
            if let _deathDate = faceIdentification.person.deathDate {
                birthDeathDateStr += _deathDate
            }
        }
        birthDeathDateLabel.text = birthDeathDateStr
 
        view.addSubview(avartarView)
        view.addSubview(nameLabel)
        view.addSubview(professionLabel)
        view.addSubview(bioLabel)
        view.addSubview(birthDeathDateLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(searchInternetForName(sender:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        // label
//        self.view.addSubview(labelInst)
//        labelInst.text = identification.person.name
//        labelInst.translatesAutoresizingMaskIntoConstraints = false
        
        setupInternalConstraints()
    }
    
    @objc func searchInternetForName(sender: SinglePersonPageViewController) {
        
        let name = self.identification.person.name
        guard let escapedString = "http://www.google.com/search?q=\(name)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else {
            gw_log("err preparing search url")
            return
        }
        
        let queryURL = URL(string:escapedString)
        let queryRequest = URLRequest(url: queryURL!)
        //webView.load(queryRequest)
        
        
        //gw_log("gw: tap detected \(self.nameLabel.text)")
        
        
        
        // gw: note, this is a tricky use of nav Controller, although SinglePersonPageVC is not directly added to nav controller
        guard let navVC = self.navigationController else {
            gw_log("err getting nav controller")
            return
        }
        
        
        
        let newViewController = WebViewController(initialURLRequest: queryRequest)
        
        DispatchQueue.main.async {
            
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInternalConstraints() {

        let views: [String: Any] = [
            "avartarView": avartarView,
            "nameLabel": nameLabel,
            "professionLabel": professionLabel,
            "bioLabel": bioLabel,
            "birthDeathDateLabel": birthDeathDateLabel
            ]
        

        
        //var avartarImageWHRatio: CGFloat = 214.0 / 317.0  // default avartar ratio in imdb celeb page
        
       
        //if let _avartarImage = avartarView.image {
        //    avartarImageWHRatio = _avartarImage.size.width / _avartarImage.size.height
        //}
        var allConstraints: [NSLayoutConstraint] = [
            
            
            
            avartarView.topAnchor.constraint(equalTo: view.topAnchor),
            avartarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avartarView.widthAnchor.constraint(equalTo: avartarView.heightAnchor, multiplier: Constants.avartarContainerViewWHRatio),
            avartarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //---- labels horizontal
            //nameLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            professionLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            //birthDeathDateLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            
            //nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            professionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            //birthDeathDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            //---- labels vertical
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            birthDeathDateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            bioLabel.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 10),
            bioLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20), // gw: to allow multiple lines: https://stackoverflow.com/a/6518460/8328365 
            bioLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
        ]
        
      
//        let labelVerticalConstrains = NSLayoutConstraint.constraints(
//            withVisualFormat: "V:|-10-[nameLabel]-10-[professionLabel]-10-[bioLabel]-10-[birthDateLabel]-10-|",
//            metrics: nil,
//            views: views)
//        allConstraints += labelVerticalConstrains
        
        let labelHorizontalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[avartarView]-20-[nameLabel]-15-[birthDeathDateLabel]-20-|",
            metrics: nil,
            views: views)
        allConstraints += labelHorizontalConstrains


        NSLayoutConstraint.activate(allConstraints)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

