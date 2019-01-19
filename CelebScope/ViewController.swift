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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let canvas:Canvas = {
        let canvas = Canvas()
        canvas.backgroundColor = UIColor.black
        canvas.translatesAutoresizingMaskIntoConstraints=false
        canvas.alpha = 0.2
        return canvas
    } ()
    
    let photoView: UIImageView = {
        let imageView = UIImageView()
            
        imageView.image = UIImage(imageLiteralResourceName: "hongjinbao")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // cannot reference self in closure
//        tableView.dataSource = self
//        tableView.delegate = self
        
       
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
     private let myArray: NSArray = ["First","Second","Third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // stack views
        view.addSubview(photoView)
        view.addSubview(canvas)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()

        
    }
    
    private func setupLayout() {

        
        photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: view.widthAnchor,   multiplier: 1.333).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        canvas.topAnchor.constraint(equalTo: photoView.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor).isActive = true
        canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor).isActive = true
        
        
        
        
        // this two works together
//        photoView.frame = view.frame
//        canvas.frame = photoView.frame
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
}

