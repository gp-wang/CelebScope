//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


class ViewController:  UIViewController {
    private struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
    }

    // canva's VC is this main VC
    let canvas:Canvas = {
        let canvas = Canvas()
        canvas.backgroundColor = UIColor.black
        canvas.translatesAutoresizingMaskIntoConstraints=false
        canvas.alpha = 0.2
        return canvas
    } ()
    

    // gw: for the person list view
    let peopleCollectionVC: CollectionViewController = {
        let _flowLayout = UICollectionViewFlowLayout()
        // set 1 x N scroll view horizontally. (otherwise it will fold down to 2nd row)
        _flowLayout.scrollDirection = .horizontal
        return CollectionViewController(collectionViewLayout: _flowLayout)
    } ()
    
    // gw: for the photo view
    let zoomableImageVC = ZoomableImageViewController()
    
    

    // Auto Layout
    var portraitConstraints = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    
    
    
    // gw: for the person details view
    let detailPagedVC: UIPageViewController = UIPageViewController()
        var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
  
    
    // manually marked face bbox in team.jpg
    var faces : [CGRect] = [
        CGRect(x: 46, y: 32, width: 140, height: 140), // Jeniffer Lawrence
        CGRect(x: 215, y: 156, width: 141, height: 141), // Ellen
        CGRect(x: 337, y: 172, width: 187, height: 187), // the Man
        CGRect(x: 524, y: 109, width: 118, height: 118), // the other Man
    
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // stack views
//        peopleCollectionVC.scrollView = UIScrollView(frame: view.frame)
//        peopleCollectionVC.scrollView?.delegate = canvas
        
        
        // gw: setting up view hierachy across multiple VC's, (should be OK per: )
        // https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/TheViewControllerHierarchy.html
        // also note we set the autolayout constraints in this main VC
        view.addSubview(peopleCollectionVC.collectionView!)
        view.addSubview(zoomableImageVC.zoomableImageView)
        // already moved inside zoomableImageView
        // zoomableImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvas)
        
        
        
        self.setupLayoutConstraints()
        // zoomableImageView.setupLayoutConstraints()
        // setupZoomableImageViewLayout()
        
        // little trick to bring inherent collectionView to front
        view.bringSubviewToFront(self.peopleCollectionVC.collectionView)
        
        peopleCollectionVC.collectionView?.backgroundColor = UIColor.white
        peopleCollectionVC.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        peopleCollectionVC.collectionView?.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: peopleCollectionVC.collectionViewCellIdentifier)
        
        
        // -- page control
        
        
        
        
    }
    
    // gw notes: use the correct lifecyle, instead of dispatch main
    override func viewDidAppear(_ animated: Bool) {
        

        
        // initial drawing
        self.adjustLayout()
        
        // gw: wait for above adjustment to finish photoView's frame
        DispatchQueue.main.async {
            
            
            let image = UIImage(imageLiteralResourceName: "team")
            self.zoomableImageVC.zoomableImageView.setImage(image: image)
            
            //self.updateAnnotation()
          
        }
//        for faceBbox in self.faces {
//            self.zoomableImageView.zoom(to: faceBbox, with: Constants.contentSpanRatio, animated: true)
//            sleep(3)
//        }
        
        
        
    }
    
    // MARK: - trait collections
    // TODO: needs more understanding and research on which appriopriate lifecycle to use
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.adjustLayout()
        //self.updateAnnotation()
        
        // need to wait for adjust layout settle
        DispatchQueue.main.async {
            self.zoomableImageVC.zoomableImageView.fitImage()
        }
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        self.adjustLayout()
//
//    }

    private func adjustLayout() {
        guard let collectionViewFlowLayout =  self.peopleCollectionVC.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        var isVerticalScroll = false
        if UIDevice.current.orientation.isLandscape {
            isVerticalScroll = true
            print("gw: adjusting to landscape")
            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)

            collectionViewFlowLayout.scrollDirection = .vertical
            // main queue likely needed to wait for correct size of bounds
            // gw: verified working
            DispatchQueue.main.async {
                collectionViewFlowLayout.itemSize = CGSize(width: self.peopleCollectionVC.collectionView.bounds.width, height: self.peopleCollectionVC.collectionView.bounds.width)
            }
            
        } else {
            isVerticalScroll = false
            print("gw: adjusting to portrait")
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)

            collectionViewFlowLayout.scrollDirection = .horizontal
            DispatchQueue.main.async {
             collectionViewFlowLayout.itemSize = CGSize(width: self.peopleCollectionVC.collectionView.bounds.height, height: self.peopleCollectionVC.collectionView.bounds.height)
            }
        }
        
        DispatchQueue.main.async {
            self.peopleCollectionVC.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    

    
    
}







// MARK: - Setup Layout constraints
extension ViewController {
    private func setupLayoutConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        
        // MARK: - portrait constraints

        
        let photo_top_p = zoomableImageView.topAnchor.constraint(equalTo: view.topAnchor)
        photo_top_p.identifier = "photo_top_p"
        portraitConstraints.append(photo_top_p)
        
        let photo_hw_ratio_p = zoomableImageView.heightAnchor.constraint(equalTo: view.widthAnchor,   multiplier: 1.333)
        photo_hw_ratio_p.identifier = "photo_hw_ratio_p"
        portraitConstraints.append(photo_hw_ratio_p)
        
        let photo_lead_p = zoomableImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        photo_lead_p.identifier = "photo_lead_p"
        portraitConstraints.append(photo_lead_p)
        
        let photo_trail_p = zoomableImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        photo_trail_p.identifier = "photo_trail_p"
        portraitConstraints.append(photo_trail_p)
        
        let canvas_top_p = canvas.topAnchor.constraint(equalTo: zoomableImageView.topAnchor)
        canvas_top_p.identifier = "canvas_top_p"
        portraitConstraints.append(canvas_top_p)
        
        let canvas_bot_p = canvas.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
        canvas_bot_p.identifier = "canvas_bot_p"
        portraitConstraints.append(canvas_bot_p)
        
        
        let canvas_lead_p = canvas.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor)
        canvas_lead_p.identifier = "canvas_lead_p"
        portraitConstraints.append(canvas_lead_p)
        
        
        let canvas_trail_p = canvas.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        canvas_trail_p.identifier = "canvas_trail_p"
        portraitConstraints.append(canvas_trail_p)
        
        let coll_top_p = collectionView.topAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
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
        
        let photo_top_l = zoomableImageView.topAnchor.constraint(equalTo: view.topAnchor)
        photo_top_l.identifier = "photo_top_l"
        landscapeConstraints.append(photo_top_l)
        
        let photo_bot_l = zoomableImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        photo_bot_l.identifier = "photo_bot_l"
        landscapeConstraints.append(photo_bot_l)
        
        let photo_wh_raio_l = zoomableImageView.widthAnchor.constraint(equalTo: view.heightAnchor,   multiplier: 1.333)
        photo_wh_raio_l.identifier = "photo_wh_raio_l"
        landscapeConstraints.append(photo_wh_raio_l)
        
        let photo_lead_l = zoomableImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        photo_lead_l.identifier = "photo_lead_l"
        landscapeConstraints.append(photo_lead_l)
        
        
        let canvas_top_l = canvas.topAnchor.constraint(equalTo: zoomableImageView.topAnchor)
        canvas_top_l.identifier = "canvas_top_l"
        landscapeConstraints.append(canvas_top_l)
        
        let canvas_bot_l = canvas.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
        canvas_bot_l.identifier = "canvas_bot_l"
        landscapeConstraints.append(canvas_bot_l)
        
        let canvas_lead_l = canvas.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor)
        canvas_lead_l.identifier = "canvas_lead_l"
        landscapeConstraints.append(canvas_lead_l)
        
        let canvas_trail_l = canvas.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        canvas_trail_l.identifier = "canvas_trail_l"
        landscapeConstraints.append(canvas_trail_l)
        
        let coll_top_l = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        coll_top_l.identifier = "coll_top_l"
        landscapeConstraints.append(coll_top_l)
        
        
        let coll_bot_l = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        coll_bot_l.identifier = "coll_bot_l"
        landscapeConstraints.append(coll_bot_l)
        
        let coll_lead_l = collectionView.leadingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
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
