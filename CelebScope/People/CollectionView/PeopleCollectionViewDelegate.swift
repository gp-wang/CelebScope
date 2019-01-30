//
//  PeopleCollectionViewDelegate.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/28/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
import UIKit


class PeopleCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // store a reference to the object which will take the actual action
    weak var actionTaker: Canvas?
    
    // the delegator who relies on this object
    unowned let delegator: UICollectionView
    
    init(delegator: UICollectionView) {
        self.delegator = delegator
        
        super.init()
    }
    
    
    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
    // here the scrollView is the people collection scrollview
    // here the canvas is the overlaying annotation layer on top of photoView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let actionTaker = actionTaker else {return }
        // print("from inside PeopleCollectionViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    
    
}


// MARK: - we want the width of collection cell size to always equal to collection View width, so we make collecton VC as the delegate of cell flow layout here (because the width info of colelction view can be accessed here)
// gw: looks like the sizing defined here prioritizes than the flow layout passed intot the collectionViewController
extension PeopleCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.delegator.bounds.width, height: self.delegator.bounds.width / 1.666)
    }
    
    
}
