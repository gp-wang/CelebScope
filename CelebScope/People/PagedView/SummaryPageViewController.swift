//
//  SummaryPageViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//



import UIKit

class SummaryPageViewController: UIViewController {
    
    let count: Int
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        return _label
    } ()
    
    init(_ count: Int) {
        
        self.count = count
        nameLabel.text = "\(count) faces detected in selected photo."
        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        
        
        
        view.addSubview(nameLabel)
        
        
        setupInternalConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInternalConstraints() {
        
        let views: [String: Any] = [
            "nameLabel": nameLabel
        ]
        
        var allConstraints: [NSLayoutConstraint] = [
            
        ]
        
        
        let labelVerticalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[nameLabel]-10-|",
            //options: .alignAllCenterX,
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstrains
        
        let labelHorizontalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[nameLabel]-10-|",
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

