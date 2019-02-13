//
//  SummaryPageViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//



import UIKit

class SummaryPageViewController: UIViewController {
    private struct Constants {
        
        static let textColor: UIColor = .white
    }
    
    let count: Int
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        _label.textAlignment = .center
        _label.textColor = Constants.textColor
        return _label
    } ()
    
    init(_ count: Int) {
        
        self.count = count
        nameLabel.text = "图片中检测到\(count)张人脸"

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // https://stackoverflow.com/a/53057960/8328365
        DispatchQueue.main.async {
             self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        }
       
    }
}

