//
//  PeoplePageViewDelegate.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


class PeoplePageViewDelegate: NSObject, UIPageViewControllerDelegate{
    
    private struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
        
    }
    
    // store a reference to the object which will take the actual action
    // action 1: zooming
    weak var zoomingActionTaker: ZoomableImageViewController?
    
    // action 2: paging
    weak var pagingActionTaker: PeoplePageViewController?
    
    
    // the delegator who relies on this object
    unowned let delegator: PeoplePageViewController
    
    init(delegator: PeoplePageViewController) {
        self.delegator = delegator
        
        // wire back to delegator
        // gw: mind the nuance difference, you chain a weak ref on a unowned ref, what can go wrong?
        // gw: actually this chaining should be OK. the bottle neck is the weak ref
        self.pagingActionTaker = delegator
        
        super.init()
    }
    
    
    
    fileprivate func pagingAndZoomingToFaceIndexed(at viewControllerIndex: Int, pagingActionTaker: PeoplePageViewController, zoomingActionTaker: ZoomableImageViewController) {
        // function body
        // set the pageControl.currentPage to the index of the current viewController in pages
        
        pagingActionTaker.pageControl.currentPage = viewControllerIndex
        
        // if current page is a single person view controller, zoom to that person's face
        if let singlePersonViewController = pagingActionTaker.pages[viewControllerIndex] as? SinglePersonPageViewController {
            
            // print("didFinishAnimating: \(viewControllerIndex)")
            // zoomingActionTaker.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
            zoomingActionTaker.zoom(to: singlePersonViewController.identification.face.rect,  animated: true)
        } else if let summaryPageViewController = pagingActionTaker.pages[viewControllerIndex] as? SummaryPageViewController {
            // self.zoomableImageVC.zoomableImageView.zoom(to: self.zoomableImageVC.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
            zoomingActionTaker.zoomableImageView.zoom(to: zoomingActionTaker.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
        } else {
            print("gw: err: unkown type of page controller in paged view ")
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // re-written in a way to easily extractable into another function
        
        // function param candidates
        guard let viewControllers = pageViewController.viewControllers as? [UIViewController] ,
            let viewControllerIndex = self.delegator.pages.index(of: viewControllers[0]),
            let pagingActionTaker = self.pagingActionTaker,
            let zoomingActionTaker = self.zoomingActionTaker
            else {
                
                print("gw: pageViewController unwrapping error")
                return
        }
        
        
        
        pagingAndZoomingToFaceIndexed(at:viewControllerIndex, pagingActionTaker: pagingActionTaker, zoomingActionTaker: zoomingActionTaker)
        
        
        
    }
}
