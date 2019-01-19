//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class Canvas : UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x:100  , y: 100)
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(7)
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        
        context.strokePath()
    }
}

class ViewController: UIViewController {

    
    let canvas:Canvas = {
        let canvas = Canvas()
        canvas.backgroundColor = UIColor.black
        canvas.alpha = 0.2
        return canvas
    } ()
    
    let photoView: UIImageView = {
        let imageView = UIImageView()
            
        imageView.image =     UIImage(imageLiteralResourceName: "hongjinbao")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // stack views
        view.addSubview(photoView)
        view.addSubview(canvas)
        
        setupLayout()

        
    }
    
    private func setupLayout() {
        
        canvas.frame = view.frame
        
        
        
        photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

}

