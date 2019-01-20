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
    
    override func loadView() {
        super.loadView()
        
        setupLayout()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // stack views
        view.addSubview(photoView)
        
        // little trick to bring inherent collectionView to front
        view.bringSubviewToFront(self.collectionView)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
        
        // initial adjusting orientation
        
        DispatchQueue.main.async {
            
            self.adjustLayout()
        }
        
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        
//        
//        
//        self.adjustLayout()
//        
//    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        self.setupLayout()
    //    }
    
    
    private func adjustLayout() {
        guard let collectionViewFlowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        
        
        
        
        if UIDevice.current.orientation.isLandscape {
            
            print("gw: adjusting to landscape")
            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)
            
            
            
            collectionViewFlowLayout.scrollDirection = .vertical
            
            
        } else {
            
            print("gw: adjusting to portrait")
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
            
            
            collectionViewFlowLayout.scrollDirection = .horizontal
        }
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - trait collections
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.adjustLayout()
    }
    
    private func setupLayout() {
        
        // MARK: - portrait constraints
        guard let collectionView = collectionView else {
            NSLog("failed to unwrap collectionView")
            return
            
        }
        
        let photo_top_p = photoView.topAnchor.constraint(equalTo: view.topAnchor)
        photo_top_p.identifier = "photo_top_p"
        portraitConstraints.append(photo_top_p)
        
        let photo_hw_ratio_p = photoView.heightAnchor.constraint(equalTo: view.widthAnchor,   multiplier: 1.333)
        photo_hw_ratio_p.identifier = "photo_hw_ratio_p"
        portraitConstraints.append(photo_hw_ratio_p)
        
        let photo_lead_p = photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        photo_lead_p.identifier = "photo_lead_p"
        portraitConstraints.append(photo_lead_p)
        
        let photo_trail_p = photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        photo_trail_p.identifier = "photo_trail_p"
        portraitConstraints.append(photo_trail_p)
        
        //        portraitConstraints.append(canvas.topAnchor.constraint(equalTo: photoView.topAnchor))
        //        portraitConstraints.append(canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor))
        //        portraitConstraints.append(canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor))
        //        portraitConstraints.append(canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor))
        
        let coll_top_p = collectionView.topAnchor.constraint(equalTo: photoView.bottomAnchor)
        coll_top_p.identifier = "coll_top_p"
        portraitConstraints.append(coll_top_p)
        
        
        let coll_bot_p = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        coll_bot_p.identifier = "coll_bot_p"
        portraitConstraints.append(coll_bot_p)
        
        let coll_lead_p = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        coll_lead_p.identifier = "coll_lead_p"
        portraitConstraints.append(coll_lead_p)
        
        let coll_trail_p = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        coll_trail_p.identifier = "coll_trail_p"
        portraitConstraints.append(coll_trail_p)
        
        for constraint in portraitConstraints {
            constraint.isActive = false
            //print("portraitConstraint: \(constraint)")
        }
        
        // MARK: - landscape constraints
        
        let photo_top_l = photoView.topAnchor.constraint(equalTo: view.topAnchor)
        photo_top_l.identifier = "photo_top_l"
        landscapeConstraints.append(photo_top_l)
        
        let photo_bot_l = photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        photo_bot_l.identifier = "photo_bot_l"
        landscapeConstraints.append(photo_bot_l)
        
        let photo_wh_raio_l = photoView.widthAnchor.constraint(equalTo: view.heightAnchor,   multiplier: 1.333)
        photo_wh_raio_l.identifier = "photo_wh_raio_l"
        landscapeConstraints.append(photo_wh_raio_l)
        
        let photo_lead_l = photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        photo_lead_l.identifier = "photo_lead_l"
        landscapeConstraints.append(photo_lead_l)
        
        
        
        //        landscapeConstraints.append(canvas.topAnchor.constraint(equalTo: photoView.topAnchor))
        //        landscapeConstraints.append(canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor))
        //        landscapeConstraints.append(canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor))
        //        landscapeConstraints.append(canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor))
        //
        
        let coll_top_l = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        coll_top_l.identifier = "coll_top_l"
        landscapeConstraints.append(coll_top_l)
        
        
        let coll_bot_l = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        coll_bot_l.identifier = "coll_bot_l"
        landscapeConstraints.append(coll_bot_l)
        
        let coll_lead_l = collectionView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor)
        coll_lead_l.identifier = "coll_lead_l"
        landscapeConstraints.append(coll_lead_l)
        
        let coll_trail_l = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        coll_trail_l.identifier = "coll_trail_l"
        landscapeConstraints.append(coll_trail_l)
        
        for constraint in landscapeConstraints {
            constraint.isActive = false
            //print("landscapeConstraint: \(constraint)")
        }
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
