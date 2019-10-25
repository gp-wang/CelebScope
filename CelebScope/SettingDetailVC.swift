//
//  SettingDetailVC.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation
import UIKit

public class SettingDetailVC: UIViewController {
    
    // gw: display s HTML
    // could not scroll, use UITextView Instead
//    let contentView: UILabel = {
//        let _label = UILabel()
//
//        _label.translatesAutoresizingMaskIntoConstraints = false
//        _label.numberOfLines = 0
//        _label.lineBreakMode = .byWordWrapping
//        return _label
//    } ()
    
    let contentView: UITextView = {
        let _textView = UITextView()
        
        _textView.translatesAutoresizingMaskIntoConstraints = false

        // gw: disable selection to avoid interferencing scrolling
        _textView.isSelectable = false
        _textView.isEditable = false
        return _textView
    } ()
    
    var contentString: String  {
        didSet {
            contentView.attributedText = contentString.htmlToAttributedString
        }
        
    }
    let name: String
    
    
    
    init(name: String, contentString: String) {
        
 
              

        self.name = name
        self.contentString = contentString
        self.contentView.attributedText = contentString.htmlToAttributedString
         // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        setupInternalConstraints()
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    func setupInternalConstraints() {
        
        
        NSLayoutConstraint.activate([
            //nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            //nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  30),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            
            ])
        
        
       
    }
    
    
}
