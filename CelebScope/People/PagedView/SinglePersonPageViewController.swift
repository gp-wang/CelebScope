//
//  ViewController.swift
//  pageViewBlog
//
//  Created by Paul Tangen on 1/26/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class SinglePersonPageViewController: UIViewController {
    
    let identification: Identification
//    let labelInst = UILabel()
    
    let avartarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        return _label
    } ()
    
    let professionLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return _label
    } ()
    
    let bioLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .body)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 4
        return _label
    } ()
    
    let birthDeathDateLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
        _label.textAlignment = .right   // first line,
        
        return _label
    } ()
    
    
    init(_ faceIdentification: Identification) {
        
        self.identification = faceIdentification
        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        
        avartarView.image = faceIdentification.person.avartar?.copy() as? UIImage
        
        nameLabel.text = faceIdentification.person.name
        
        professionLabel.text = faceIdentification.person.profession
        
        
        bioLabel.text = faceIdentification.person.bio ?? ""
 
        var birthDeathDateStr = ""
        if let _birthDate = faceIdentification.person.birthDate {
            birthDeathDateStr = Utils.yearFormatter.string(from:_birthDate) + " - "
            if let _deathDate = faceIdentification.person.deathDate {
                birthDeathDateStr += Utils.yearFormatter.string(from:_deathDate)
            }
        }
        birthDeathDateLabel.text = birthDeathDateStr
 
        
        view.addSubview(avartarView)
        view.addSubview(nameLabel)
        view.addSubview(professionLabel)
        view.addSubview(bioLabel)
        view.addSubview(birthDeathDateLabel)
        
        // label
//        self.view.addSubview(labelInst)
//        labelInst.text = identification.person.name
//        labelInst.translatesAutoresizingMaskIntoConstraints = false
        
        setupInternalConstraints()
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
        

        
        var avartarImageWHRatio: CGFloat = 214.0 / 317.0  // default avartar ratio in imdb celeb page
        if let _avartarImage = avartarView.image {
            avartarImageWHRatio = _avartarImage.size.width / _avartarImage.size.height
        }
        var allConstraints: [NSLayoutConstraint] = [
            
            
            
            avartarView.topAnchor.constraint(equalTo: view.topAnchor),
            avartarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avartarView.widthAnchor.constraint(equalTo: avartarView.heightAnchor, multiplier: avartarImageWHRatio),
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

