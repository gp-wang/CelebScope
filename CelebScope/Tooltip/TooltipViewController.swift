//
//  TooltipVC.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 2/9/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit
import CoreGraphics


// gw: dedicated VC for the photoView
class TooltipViewController: UIViewController {
    struct Constants {
        
        static let tooltipWidth: CGFloat = 200
        static let tooltipHeight: CGFloat = 80
    }
    
    
    let mainTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "1. Pick a photo with famous faces."
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    let resultTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "4. Find results here. Tap to search web."
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    let cameraButtonTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false

        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "2. Use camera to capture a photo"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .left
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                 metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    let albumButtonTooltip: UIView = {
        
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "3. Use album to select a photo"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .right
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    // the shade to dim content below it
    let blinds: UIView = {
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = .black
        container.alpha = 0.6
        
        return container
    } ()
    
    var allConstraints = [NSLayoutConstraint] ()
    var portraitConstraints = [NSLayoutConstraint] ()
    var landscapeConstraints = [NSLayoutConstraint] ()
    
    unowned let cameraButton: UIButton
    unowned let albumButton: UIButton
    unowned let zoomableImageView: UIView
    unowned let peoplePageView: UIView
    unowned let peopleCollectionView: UIView
    
    
    // note: parentViewController param is needed to add subview and child
    public init(cameraButton: UIButton, albumButton: UIButton, zoomableImageView: UIView, peopleCollectionView: UIView, peoplePageView: UIView) {
        self.cameraButton = cameraButton
        self.albumButton = albumButton
        self.zoomableImageView = zoomableImageView
        self.peopleCollectionView = peopleCollectionView
        self.peoplePageView = peoplePageView
        
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.clear
        
        

        view.addSubview(blinds)
        view.addSubview(mainTooltip)
        view.addSubview(cameraButtonTooltip)
        view.addSubview(albumButtonTooltip)
        view.addSubview(resultTooltip)
        
        // gw: move this out and call separately, ONLY AFTER you added subview of parent VC
        //setupTooltipLayoutConstraints()
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.adjustLayout()
//        let bubbleLayer = CAShapeLayer()
//        let path: UIBezierPath = bubblePathForContentSize(contentSize: cameraButtonTooltip.bounds.size.applying(CGAffineTransform(scaleX: 0.3, y: 0.3)))
//            path.apply(CGAffineTransform(rotationAngle: .pi))
//        bubbleLayer.path = path.cgPath
//        bubbleLayer.fillColor = UIColor.yellow.cgColor
//        bubbleLayer.strokeColor = UIColor.blue.cgColor
//        bubbleLayer.lineWidth = borderWidth
//        bubbleLayer.position = CGPoint.zero
//        cameraButtonTooltip.layer.addSublayer(bubbleLayer)
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  
    // dialog box with arrow: https://stackoverflow.com/a/33388089/8328365
    var borderWidth : CGFloat = 4 // Should be less or equal to the `radius` property
    var radius : CGFloat = 10
    var triangleHeight : CGFloat = 15
    
//    private func bubblePathForContentSize(contentSize: CGSize) -> UIBezierPath {
//        //let rect = CGRectMake(0, 0, contentSize.width, contentSize.height).offsetBy(dx: radius, dy: radius + triangleHeight)
//        let rect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height).offsetBy(dx: radius, dy: radius + triangleHeight)
//        let path = UIBezierPath();
//        let radius2 = radius - borderWidth / 2 // RadiusaddLinetto: he border width
//
//        path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
//        path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY), radius: radius2, startAngle: CGFloat(-M_PI_2), endAngle: 0, clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius2, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY), radius: radius2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY), radius: radius2, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI_2), clockwise: true)
//        path.close()
//
//        return path
//    }
//
    
    
    
    public func setupTooltipLayoutConstraints() {

        
        
        // MARK: - all constraints
        
        let mainTooltip_width_all = mainTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        mainTooltip_width_all.identifier = "mainTooltip_width_all"
        mainTooltip_width_all.isActive = false
        allConstraints.append(mainTooltip_width_all)
        
        let mainTooltip_height_all = mainTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        mainTooltip_height_all.identifier = "mainTooltip_height_all"
        mainTooltip_height_all.isActive = false
        allConstraints.append(mainTooltip_height_all)
        
        let mainTooltip_centerX_all = mainTooltip.centerXAnchor.constraint(equalTo: self.zoomableImageView.centerXAnchor)
        mainTooltip_centerX_all.identifier = "mainTooltip_centerX_all"
        mainTooltip_centerX_all.isActive = false
        allConstraints.append(mainTooltip_centerX_all)
        
        let mainTooltip_centerY_all = mainTooltip.centerYAnchor.constraint(equalTo: self.zoomableImageView.centerYAnchor)
        mainTooltip_centerY_all.identifier = "mainTooltip_centerY_all"
        mainTooltip_centerY_all.isActive = false
        allConstraints.append(mainTooltip_centerY_all)
        
        
        // ------
        let cameraButtonTooltip_width_all = cameraButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        cameraButtonTooltip_width_all.identifier = "cameraButtonTooltip_width_all"
        cameraButtonTooltip_width_all.isActive = false
        allConstraints.append(cameraButtonTooltip_width_all)
        
        let cameraButtonTooltip_height_all = cameraButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        cameraButtonTooltip_height_all.identifier = "cameraButtonTooltip_height_all"
        cameraButtonTooltip_height_all.isActive = false
        allConstraints.append(cameraButtonTooltip_height_all)
        
        let cameraButtonTooltip_lead_all = cameraButtonTooltip.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor)
        cameraButtonTooltip_lead_all.identifier = "cameraButtonTooltip_lead_all"
        cameraButtonTooltip_lead_all.isActive = false
        allConstraints.append(cameraButtonTooltip_lead_all)
        
        let cameraButtonTooltip_bot_all = cameraButtonTooltip.bottomAnchor.constraint(equalTo: self.cameraButton.topAnchor, constant: -10)
        cameraButtonTooltip_bot_all.identifier = "cameraButtonTooltip_bot_all"
        cameraButtonTooltip_bot_all.isActive = false
        allConstraints.append(cameraButtonTooltip_bot_all)
        
        
        let albumButtonTooltip_width_all = albumButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        albumButtonTooltip_width_all.identifier = "albumButtonTooltip_width_all"
        albumButtonTooltip_width_all.isActive = false
        allConstraints.append(albumButtonTooltip_width_all)
        
        let albumButtonTooltip_height_all = albumButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        albumButtonTooltip_height_all.identifier = "albumButtonTooltip_height_all"
        albumButtonTooltip_height_all.isActive = false
        allConstraints.append(albumButtonTooltip_height_all)
        
        let albumButtonTooltip_trailing_all = albumButtonTooltip.trailingAnchor.constraint(equalTo: self.albumButton.trailingAnchor)
        albumButtonTooltip_trailing_all.identifier = "albumButtonTooltip_trailing_all"
        albumButtonTooltip_trailing_all.isActive = false
        allConstraints.append(albumButtonTooltip_trailing_all)
        
        let albumButtonTooltip_bot_all = albumButtonTooltip.bottomAnchor.constraint(equalTo: self.albumButton.topAnchor, constant: -10)
        albumButtonTooltip_bot_all.identifier = "albumButtonTooltip_bot_all"
        albumButtonTooltip_bot_all.isActive = false
        allConstraints.append(albumButtonTooltip_bot_all)
        
        // -------------
        
        let resultTooltip_width_p = resultTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        resultTooltip_width_p.identifier = "resultTooltip_width_p"
        resultTooltip_width_p.isActive = false
        portraitConstraints.append(resultTooltip_width_p)
        
        let resultTooltip_height_p = resultTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        resultTooltip_height_p.identifier = "resultTooltip_height_p"
        resultTooltip_height_p.isActive = false
        portraitConstraints.append(resultTooltip_height_p)
        
        let resultTooltip_centerX_p = resultTooltip.centerXAnchor.constraint(equalTo: self.peoplePageView.centerXAnchor)
        resultTooltip_centerX_p.identifier = "resultTooltip_centerX_p"
        resultTooltip_centerX_p.isActive = false
        portraitConstraints.append(resultTooltip_centerX_p)
        
        let resultTooltip_centerY_p = resultTooltip.centerYAnchor.constraint(equalTo: self.peoplePageView.centerYAnchor)
        resultTooltip_centerY_p.identifier = "resultTooltip_centerY_p"
        resultTooltip_centerY_p.isActive = false
        portraitConstraints.append(resultTooltip_centerY_p)
        
        let resultTooltip_width_l = resultTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        resultTooltip_width_l.identifier = "resultTooltip_width_l"
        resultTooltip_width_l.isActive = false
        landscapeConstraints.append(resultTooltip_width_l)
        
        let resultTooltip_height_l = resultTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        resultTooltip_height_l.identifier = "resultTooltip_height_l"
        resultTooltip_height_l.isActive = false
        landscapeConstraints.append(resultTooltip_height_l)
        
        let resultTooltip_centerX_l = resultTooltip.centerXAnchor.constraint(equalTo: self.peopleCollectionView.centerXAnchor)
        resultTooltip_centerX_l.identifier = "resultTooltip_centerX_l"
        resultTooltip_centerX_l.isActive = false
        landscapeConstraints.append(resultTooltip_centerX_l)
        
        let resultTooltip_centerY_l = resultTooltip.centerYAnchor.constraint(equalTo: self.peopleCollectionView.centerYAnchor)
        resultTooltip_centerY_l.identifier = "resultTooltip_centerY_l"
        resultTooltip_centerY_l.isActive = false
        landscapeConstraints.append(resultTooltip_centerY_l)
        
        
        allConstraints += [
            blinds.topAnchor.constraint(equalTo: self.view.topAnchor),
            blinds.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            blinds.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blinds.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(allConstraints)
        
        // TODO: add landscape
    }
    
    
    public func adjustLayout() {

        
        if UIDevice.current.orientation.isLandscape {

            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)
        
            
        } else {

            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
    
        }

    }
}
