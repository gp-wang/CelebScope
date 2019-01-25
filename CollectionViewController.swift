//
//  CollectionViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC class for the person collection view
class CollectionViewController: UIViewController {

     let collectionViewCellIdentifier = "MyCollectionViewCellIdentifier"
    
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
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
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
