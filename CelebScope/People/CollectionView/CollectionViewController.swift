//
//  CollectionViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC class for the person collection view
class CollectionViewController: UICollectionViewController {

     let collectionViewCellIdentifier = "MyCollectionViewCellIdentifier"
    
    var identifications: [Identification] = [] {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    
    
    
    public func populate(identifications: [Identification])  {
        
        self.identifications = identifications
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: gw: we use the implicit member "collectionView?" of UICollectionViewController
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        
        // TODO: try out
        //collectionView =  CustomUICollectionView()
        super.init(collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}



// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath)
        
        guard let personCollectionViewCell = cell as? PersonCollectionViewCell else {
            
            print("error cannot get valid collection cell, returning dummy cell")
            return cell }
        
        personCollectionViewCell.identification = self.identifications[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.identifications.count
    }
    
    
}

// gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
// MARK: - scrollView(name list) update location
//extension CollectionViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//        self.updateAnnotation()
//
//    }
//}


// MARK: - we want the width of collection cell size to always equal to collection View width, so we make collecton VC as the delegate of cell flow layout here (because the width info of colelction view can be accessed here)
// gw: looks like the sizing defines here prioritizes than the flow layout passed intot the collectionViewController
// gw: tried to move this to PeopleCollectionViewDelegate, result is working now
//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
// 
//        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.width / 1.666)
//    }
//}
