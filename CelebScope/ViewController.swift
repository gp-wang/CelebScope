//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


class ViewController: UICollectionViewController{

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
    
    var portraitConstraints = [NSLayoutConstraint]()
    
    var landscapeConstraints = [NSLayoutConstraint]()
    
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

        // initial adjusting orientation
        let deviceOrientation = UIDevice.current.orientation
        DispatchQueue.main.async {
            self.adjustLayout(for: deviceOrientation)
        }
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let deviceOrientation = UIDevice.current.orientation
        DispatchQueue.main.async {
            self.adjustLayout(for: deviceOrientation)
        }
    }
    
    private func setupLayout() {

        // MARK: - portrait constraints
        guard let collectionView = collectionView else {
             NSLog("failed to unwrap collectionView")
            return
            
        }
        portraitConstraints.append(photoView.topAnchor.constraint(equalTo: view.topAnchor))
        portraitConstraints.append(photoView.heightAnchor.constraint(equalTo: view.widthAnchor,   multiplier: 1.333))
        portraitConstraints.append(photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        portraitConstraints.append(photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        portraitConstraints.append(canvas.topAnchor.constraint(equalTo: photoView.topAnchor))
        portraitConstraints.append(canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor))
        portraitConstraints.append(canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor))
        portraitConstraints.append(canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor))
        
        portraitConstraints.append(collectionView.topAnchor.constraint(equalTo: photoView.bottomAnchor))
        portraitConstraints.append(collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        portraitConstraints.append(collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        portraitConstraints.append(collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        // MARK: - landscape constraints
       
        landscapeConstraints.append(photoView.topAnchor.constraint(equalTo: view.topAnchor))
        landscapeConstraints.append(photoView.widthAnchor.constraint(equalTo: view.heightAnchor,   multiplier: 1.333))
        landscapeConstraints.append(photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        landscapeConstraints.append(photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        landscapeConstraints.append(canvas.topAnchor.constraint(equalTo: photoView.topAnchor))
        landscapeConstraints.append(canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor))
        landscapeConstraints.append(canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor))
        landscapeConstraints.append(canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor))
        
        landscapeConstraints.append(collectionView.topAnchor.constraint(equalTo: view.topAnchor))
        landscapeConstraints.append(collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        landscapeConstraints.append(collectionView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor))
        landscapeConstraints.append(collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        
    }
    
    private func adjustLayout(for deviceOrientation: UIDeviceOrientation) {
        guard let collectionViewFlowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        
        print("gw: deviceOrientation.isLandscape: \(deviceOrientation.isLandscape)")
        
        if deviceOrientation.isLandscape {
            for constraint in landscapeConstraints {
                
                constraint.isActive = true
                print("gw: enable: \(constraint)")
            }
            
            for constraint in portraitConstraints {
               
                constraint.isActive = false
                 print("gw: disable: \(constraint)")
            }
            // not working if set here
            collectionViewFlowLayout.scrollDirection = .vertical
            
            
        } else {
            for constraint in landscapeConstraints {
                
                constraint.isActive = false
                print("gw: disable: \(constraint)")
            }
            
            for constraint in portraitConstraints {
                
                constraint.isActive = true
                print("gw: enable: \(constraint)")
            }
            
            collectionViewFlowLayout.scrollDirection = .horizontal
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}


// MARK: - UICollectionViewDataSource
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    // set item size 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // gw: to force one row, height need to be smaller than flow height
        return CGSize(width: 200, height: collectionView.bounds.height)
    }
}
