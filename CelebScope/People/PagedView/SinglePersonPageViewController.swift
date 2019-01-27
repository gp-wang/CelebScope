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
        _label.text = "Xxxxxxxxx"
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
        

        var allConstraints: [NSLayoutConstraint] = []
      
        
        
        

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

