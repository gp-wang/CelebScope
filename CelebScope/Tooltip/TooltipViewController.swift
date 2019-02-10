//
//  TooltipVC.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 2/9/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC for the photoView
class TooltipViewController: UIViewController {
    struct Constants {
        
        static let tooltipSize: CGFloat = 100
    }
    
    
    
    let cameraButtonTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = .red
        
        return container
        
    } ()
    
    
    let albumButtonTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = .red
        
        return container
        
    } ()
    
    var allConstraints = [NSLayoutConstraint] ()
    
    unowned let cameraButton: UIButton
    unowned let albumButton: UIButton
    
    
    // note: parentViewController param is needed to add subview and child
    public init(cameraButton: UIButton, albumButton: UIButton) {
        self.cameraButton = cameraButton
        self.albumButton = albumButton
        
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = .clear
        
        view.addSubview(cameraButtonTooltip)
        view.addSubview(albumButtonTooltip)
        
        // gw: move this out and call separately, ONLY AFTER you added subview of parent VC
        //setupTooltipLayoutConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  
    
    
    public func setupTooltipLayoutConstraints() {

        
        
        // MARK: - portrait constraints
        
        let cameraButtonTooltip_width_p = cameraButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipSize)
        cameraButtonTooltip_width_p.identifier = "cameraButtonTooltip_width_p"
        cameraButtonTooltip_width_p.isActive = false
        allConstraints.append(cameraButtonTooltip_width_p)
        
        let cameraButtonTooltip_height_p = cameraButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipSize)
        cameraButtonTooltip_height_p.identifier = "cameraButtonTooltip_height_p"
        cameraButtonTooltip_height_p.isActive = false
        allConstraints.append(cameraButtonTooltip_height_p)
        
        let cameraButtonTooltip_lead_p = cameraButtonTooltip.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor)
        cameraButtonTooltip_lead_p.identifier = "cameraButtonTooltip_lead_p"
        cameraButtonTooltip_lead_p.isActive = false
        allConstraints.append(cameraButtonTooltip_lead_p)
        
        let cameraButtonTooltip_bot_p = cameraButtonTooltip.bottomAnchor.constraint(equalTo: self.cameraButton.topAnchor, constant: -10)
        cameraButtonTooltip_bot_p.identifier = "cameraButtonTooltip_bot_p"
        cameraButtonTooltip_bot_p.isActive = false
        allConstraints.append(cameraButtonTooltip_bot_p)
        
        
        let albumButtonTooltip_width_p = albumButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipSize)
        albumButtonTooltip_width_p.identifier = "albumButtonTooltip_width_p"
        albumButtonTooltip_width_p.isActive = false
        allConstraints.append(albumButtonTooltip_width_p)
        
        let albumButtonTooltip_height_p = albumButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipSize)
        albumButtonTooltip_height_p.identifier = "albumButtonTooltip_height_p"
        albumButtonTooltip_height_p.isActive = false
        allConstraints.append(albumButtonTooltip_height_p)
        
        let albumButtonTooltip_trailing_p = albumButtonTooltip.trailingAnchor.constraint(equalTo: self.albumButton.trailingAnchor)
        albumButtonTooltip_trailing_p.identifier = "albumButtonTooltip_trailing_p"
        albumButtonTooltip_trailing_p.isActive = false
        allConstraints.append(albumButtonTooltip_trailing_p)
        
        let albumButtonTooltip_bot_p = albumButtonTooltip.bottomAnchor.constraint(equalTo: self.albumButton.topAnchor, constant: -10)
        albumButtonTooltip_bot_p.identifier = "albumButtonTooltip_bot_p"
        albumButtonTooltip_bot_p.isActive = false
        allConstraints.append(albumButtonTooltip_bot_p)
      
        NSLayoutConstraint.activate(allConstraints)
    }
    
}
