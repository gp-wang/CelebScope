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
        return imageView
    } ()
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.text = "Xxxxxxxxx"
        return _label
    } ()
    let professionLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.text = "Xxxxxxxxx"
        return _label
    } ()
    let bioLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.text = "Xxxxxxxxx Xxxxxxxxx Xxxxxxxxx Xxxxxxxxx Xxxxxxxxx Xxxxxxxxx Xxxxxxxxx"
        return _label
    } ()
    let birthDateLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.text = "Xxxxxxxxx"
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
        if let _birthDate = faceIdentification.person.birthDate {
            birthDateLabel.text = Utils.yearFormatter.string(from:_birthDate)
        }
        
        
        view.addSubview(avartarView)
        view.addSubview(nameLabel)
        view.addSubview(professionLabel)
        view.addSubview(bioLabel)
        view.addSubview(birthDateLabel)
        
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
            "birthDateLabel": birthDateLabel
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
            nameLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            professionLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            birthDateLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            //---- labels vertical
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            bioLabel.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 20),
            birthDateLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
        ]
        
      
//        let labelVerticalConstrains = NSLayoutConstraint.constraints(
//            withVisualFormat: "V:|-20-[nameLabel]-15-[professionLabel]-15-[bioLabel]-15-[birthDateLabel]-15-|",
//            metrics: nil,
//            views: views)
//        allConstraints += labelVerticalConstrains


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

