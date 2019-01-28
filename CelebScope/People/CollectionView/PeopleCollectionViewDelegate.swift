//
//  PeopleCollectionViewDelegate.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/28/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
import UIKit


class PeopleCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    
    let parentCanvas: Canvas
    let wrapperView: UICollectionView
    
    init(wapperView: UICollectionView, parentCanvas: Canvas) {
        self.wrapperView = wapperView
        self.parentCanvas = parentCanvas
        super.init()
    }
    
    
    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
    // here the scrollView is the people collection scrollview
    // here the canvas is the overlaying annotation layer on top of photoView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("from inside PeopleCollectionViewDelegate")
        parentCanvas.updateAnnotation(scrollView: scrollView)
    }
    
    
    
}
