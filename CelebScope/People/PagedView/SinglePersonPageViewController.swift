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
    let labelInst = UILabel()
    init(_ faceIdentification: Identification) {
        
        self.identification = faceIdentification
        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)

        
        // label
        
        self.view.addSubview(labelInst)
        labelInst.text = identification.person.name
        labelInst.translatesAutoresizingMaskIntoConstraints = false
        
        setupInternalConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInternalConstraints() {
        labelInst.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        labelInst.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
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

