//
//  DemoManager.swift
//  CelebScope
// in chargge of demoing some preset photos when user has not selected any photo yet
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//



import UIKit
import FaceCropper

class DemoManager: NSObject {
    
    private struct Constants {
        static let period = 2 //seconds
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    private var isOn = true
    
    private let demos: [Demo] = Demos.demos
    
    unowned let zoomingActionTaker: ZoomableImageViewController
    unowned let pagingActionTaker: PeoplePageViewController
    
    init(zoomingActionTaker: ZoomableImageViewController, pagingActionTaker: PeoplePageViewController) {
        
        self.zoomingActionTaker = zoomingActionTaker
        self.pagingActionTaker = pagingActionTaker
        
        
        super.init()
        print("gw: init demo mgr")
        // 1
        
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let demos = self?.demos, let count = self?.demos.count else {
                print("gw: error demos array")
                return
            }
            
            print("starting photo showing")
            
            // init
            // set photo here

            // populate paged VC
            var i: Int = 0
            
            
            // process cycle
            while true {
                if let isOn = self?.isOn {
                    if !isOn {
                        break
                    }
                } else {
                    // gw: this is needed when self is destructed and we want to stop the photoshowing task
                    break
                }
 
                print("showing some photo for 2 sec ...")
                
                //scroll one page here
                let demo = demos[i]
                DispatchQueue.main.async {
                    zoomingActionTaker.setImage(image: demo.photo)
                    pagingActionTaker.populate(identificationResults: demo.identifications)
                }
                
                
                
                for (idx, page) in pagingActionTaker.pages.enumerated() {
                    // pagingActionTaker.delegate
                    DispatchQueue.main.async {
                        //pagingActionTaker.pageControl.currentPage = idx
                        pagingActionTaker.scrollToPage(idx)

                    }
                    
                    // if current page is a single person view controller, zoom to that person's face
                    if let singlePersonViewController = page as? SinglePersonPageViewController {
                        
                        // print("didFinishAnimating: \(viewControllerIndex)")
                        // zoomingActionTaker.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
                        DispatchQueue.main.async {
                         zoomingActionTaker.zoom(to: singlePersonViewController.identification.face.rect, animated: true)
                        }
                        
                    } else if let summaryPageViewController = page as? SummaryPageViewController {
                        // self.zoomableImageVC.zoomableImageView.zoom(to: self.zoomableImageVC.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
                        
                        DispatchQueue.main.async {
                             zoomingActionTaker.zoom(to: zoomingActionTaker.zoomableImageView.imageView.bounds, animated: true)
                        }
                       
                    } else {
                        print("gw: err: unkown type of page controller in paged view ")
                    }
                    
                    sleep(2)
                    print("gw: scroll one face")
                    
                }
                

                
                sleep(2)
                print("gw: scroll one photo")

                i = (i + 1) % count
            }
            
            // tear down
            
            // clearn identifications here
            
            
            print("finished photo showing")
        }
        
       
    }
    
    
    
    
    deinit {
        print("deiniting demoMenager")
        self.isOn = false
    }
    
    
    func initDemos() {
        
        
    }
    
    
}
