//
//  PeoplePageViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit



class PeoplePageViewController: UIPageViewController {
    

    
    var pages = [SinglePersonPageViewController]()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    public func populate(identificationResults: [Identification]) {
     
        
        for identification in identificationResults {
            var page = SinglePersonPageViewController(identification)
            pages.append(page)
        }
        
        let initialPage = 0
        self.pageControl.currentPage = initialPage
    }
    
    
    // MARK: - Constructors
    init() {
        
        // gw: has to use this constructor because super.init() does not exists, the param here is for dummy purpose
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.dataSource = self
        //gw: moved to main VC
        //self.delegate = self

        
        // pageControl
        // gw: modified
        // self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
       
        
        
        self.view.addSubview(self.pageControl)

        self.view.translatesAutoresizingMaskIntoConstraints = false         // gw: note to add this
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        setupInternalLayoutConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupInternalLayoutConstraints() {
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}


// MARK: - UIPageViewControllerDataSource
extension PeoplePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        
        print("viewControllerBefore")
        

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        
        print("viewControllerAfter")
        return nil
    }
}


// MARK: - UIPageViewControllerDelegate
// gw: moved to main View Controller because we need to act on zoomableImageView
//extension PeoplePageViewController: UIPageViewControllerDelegate {
//
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        
//        // set the pageControl.currentPage to the index of the current viewController in pages
//        if let viewControllers = pageViewController.viewControllers {
//            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
//                self.pageControl.currentPage = viewControllerIndex
//                print("didFinishAnimating: \(viewControllerIndex)")
//            }
//        }
//        
//        
//    }
//}