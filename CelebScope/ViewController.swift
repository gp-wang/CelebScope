//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit



class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let collectionViewCellIdentifier = "MyCollectionViewCellIdentifier"
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
    
    
     private let myArray: NSArray = ["First","Second","Third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // stack views
        view.addSubview(photoView)
        view.addSubview(canvas)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)

        
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
        
        collectionView?.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: photoView.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: photoView.trailingAnchor).isActive = true
        
        
        
        
        // this two works together
//        photoView.frame = view.frame
//        canvas.frame = photoView.frame
    }
    
    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
   
    
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    

    
    
    
    
    
}
