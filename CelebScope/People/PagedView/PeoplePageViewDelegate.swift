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
    // View Controller has a method to do zooming and paging together
    weak var actionTaker: ViewController?
    
    
    // the delegator who relies on this object
    unowned let delegator: PeoplePageViewController
    
    init(delegator: PeoplePageViewController) {
        self.delegator = delegator
        
        super.init()
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // re-written in a way to easily extractable into another function
        
        // function param candidates
        guard let viewControllers = pageViewController.viewControllers as? [UIViewController] ,
            let viewControllerIndex = self.delegator.pages.index(of: viewControllers[0])
        
            else {
                
                print("gw: pageViewController unwrapping error 1")
                return
        }
        
        self.actionTaker?.pagingAndZoomingToFaceIndexed(at: viewControllerIndex)
        
        
    }
}
