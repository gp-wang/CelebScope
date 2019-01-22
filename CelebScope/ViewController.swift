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
        
        imageView.image = UIImage(imageLiteralResourceName: "kelly") // cross point at pixel: 700 x 650, total size: 1200 x 1500
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    // convenience flag of scroll direction of collection view
    var isVerticalScroll : Bool?
    
    var portraitConstraints = [NSLayoutConstraint]()
    
    var landscapeConstraints = [NSLayoutConstraint]()
    
    var visibleCellIndices = [IndexPath]()
    
    // TODO:
    // var faceLocationsInCgImage = [CGPoint]()
    var faceLocationsInCgImage : [CGPoint] = [
    
        CGPoint(x: 100, y: 100),
        CGPoint(x: 700, y: 100),
        CGPoint(x: 1100, y: 100),
        
        CGPoint(x: 100, y: 650),
        CGPoint(x: 700, y: 650),
        CGPoint(x: 1100, y: 650),
        
        CGPoint(x: 100, y: 1400),
        CGPoint(x: 700, y: 1400),
        CGPoint(x: 1100, y: 1400),
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // stack views
        view.addSubview(photoView)
        view.addSubview(canvas)
        setupLayoutConstraints()

        
        // little trick to bring inherent collectionView to front
        view.bringSubviewToFront(self.collectionView)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
    }
    
    // gw notes: use the correct lifecyle, instead of dispatch main
    override func viewDidAppear(_ animated: Bool) {
        
        // initial drawing
        self.adjustLayout()
        self.updateAnnotation()
    }
    
    // MARK: - trait collections
    // TODO: needs more understanding and research on which appriopriate lifecycle to use
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.adjustLayout()
        self.updateAnnotation()
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        self.adjustLayout()
//
//    }

    private func adjustLayout() {
        guard let collectionViewFlowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        
        if UIDevice.current.orientation.isLandscape {
            self.isVerticalScroll = true
            print("gw: adjusting to landscape")
            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)

            collectionViewFlowLayout.scrollDirection = .vertical
            // main queue likely needed to wait for correct size of bounds
            // gw: verified working
            DispatchQueue.main.async {
                collectionViewFlowLayout.itemSize = CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.width)
            }
            
        } else {
            self.isVerticalScroll = false
            print("gw: adjusting to portrait")
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)

            collectionViewFlowLayout.scrollDirection = .horizontal
            DispatchQueue.main.async {
             collectionViewFlowLayout.itemSize = CGSize(width: self.collectionView.bounds.height, height: self.collectionView.bounds.height)
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    private func updateAnnotation() {
        
        guard let isVerticalScroll = self.isVerticalScroll else {
            print("should have a scrool direction")
            return
        }
        
        DispatchQueue.main.async {

            self.canvas.pairs.removeAll()
            
            // gw: likely no need to place in dispatch main because at this calling time (scrollView did scroll), these frames are guaranteed to exist
            // gw: because scrolling changes visible cells, we need to do canvas.pairs update in this lifecycle as well
            
            for (i,cell) in self.collectionView.visibleCells.enumerated() {
                
                // assume only one section
                let index_in_all_cells = self.collectionView.indexPathsForVisibleItems[i].row
                let startPoint = self.photoView.convertPoint(fromImagePoint:  self.faceLocationsInCgImage[index_in_all_cells])
                
                var endPoint = self.collectionView.convert(cell.frame.origin, to: self.canvas)
                // flag for orientation determination
                if isVerticalScroll {
                    endPoint = endPoint.applying(CGAffineTransform(translationX: cell.bounds.height / 2, y: 0   ))
                    
                } else {
                    endPoint = endPoint.applying(CGAffineTransform(translationX: cell.bounds.width / 2, y: 0   ))
                }
                
                self.canvas.pairs.append((startPoint, endPoint, isVerticalScroll))
                
            }
            
             self.canvas.setNeedsDisplay()
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
        return 9
    }
    
    
}


// MARK: - UICollectionViewDelegateFlowLayout
//extension ViewController : UICollectionViewDelegateFlowLayout {
//
//    // set item size
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        // gw: to force one row, height need to be smaller than flow height
//        return CGSize(width: 200, height: collectionView.bounds.height)
//    }
//}


// MARK: - scrollView update location
extension ViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        
        self.updateAnnotation()

    }
}


// MARK: - Setup Layout constraints
extension ViewController {
    private func setupLayoutConstraints() {
        
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
        
        let canvas_top_p = canvas.topAnchor.constraint(equalTo: photoView.topAnchor)
        canvas_top_p.identifier = "canvas_top_p"
        portraitConstraints.append(canvas_top_p)
        
        let canvas_bot_p = canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor)
        canvas_bot_p.identifier = "canvas_bot_p"
        portraitConstraints.append(canvas_bot_p)
        
        
        let canvas_lead_p = canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor)
        canvas_lead_p.identifier = "canvas_lead_p"
        portraitConstraints.append(canvas_lead_p)
        
        
        let canvas_trail_p = canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor)
        canvas_trail_p.identifier = "canvas_trail_p"
        portraitConstraints.append(canvas_trail_p)
        
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
        
        
        let canvas_top_l = canvas.topAnchor.constraint(equalTo: photoView.topAnchor)
        canvas_top_l.identifier = "canvas_top_l"
        landscapeConstraints.append(canvas_top_l)
        
        let canvas_bot_l = canvas.bottomAnchor.constraint(equalTo: photoView.bottomAnchor)
        canvas_bot_l.identifier = "canvas_bot_l"
        landscapeConstraints.append(canvas_bot_l)
        
        let canvas_lead_l = canvas.leadingAnchor.constraint(equalTo: photoView.leadingAnchor)
        canvas_lead_l.identifier = "canvas_lead_l"
        landscapeConstraints.append(canvas_lead_l)
        
        let canvas_trail_l = canvas.trailingAnchor.constraint(equalTo: photoView.trailingAnchor)
        canvas_trail_l.identifier = "canvas_trail_l"
        landscapeConstraints.append(canvas_trail_l)
        
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
