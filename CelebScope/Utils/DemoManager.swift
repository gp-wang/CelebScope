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
        static let period: Double = 2 //seconds
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    private var isOn = true
    
    private let demos: [Demo] = Demos.demos
    
    unowned let zoomingActionTaker: ZoomableImageViewController
    unowned let pagingActionTaker: PeoplePageViewController
    unowned let  collectionVC: CollectionViewController
    // gw: needed here, otherwise will cause annotation error
    // TODO: think about moving the scroll as one method into main VC, and call it from here
    unowned let canvas: Canvas
    
    init(zoomingActionTaker: ZoomableImageViewController, pagingActionTaker: PeoplePageViewController, collectionVC: CollectionViewController, canvas: Canvas) {
        
        self.zoomingActionTaker = zoomingActionTaker
        self.pagingActionTaker = pagingActionTaker
        self.collectionVC = collectionVC
        self.canvas = canvas
        
        super.init()
        print("gw: init demo mgr")
        // 1
        
        
        DispatchQueue.global(qos: .userInteractive).async  { [weak self] in
            guard let demos = self?.demos,
                let count = self?.demos.count
            else {
                print("gw: error unwrapping in demo mgr")
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
                DispatchQueue.main.async{
                    zoomingActionTaker.setImage(image: demo.photo)
                    pagingActionTaker.populate(identificationResults: demo.identifications)
                    collectionVC.populate(identifications: demo.identifications)
                    canvas.identifications = demo.identifications
                    gw_log("gw: populated demo, going to face scrolling after \(Constants.period) sec...")
                }
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.period, execute: {
                    gw_log("gw: face scroll start")
                    for (idx, page) in pagingActionTaker.pages.enumerated() {
                       // if (idx == 0) {
                            // overview page
                            // already been shown for for Constants.period
                           // continue
                        //}
                        
                        
                        // pagingActionTaker.delegate
                        //DispatchQueue.main.async {
                        //pagingActionTaker.pageControl.currentPage = idx
                        
                        // gw: note that the item delay should multiply by idx
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(idx) * Constants.period), execute: {
                            
                            gw_log("gw: scrolling to face \(idx)")
                            pagingActionTaker.scrollToPage(idx)
                            
                            //}
                            
                            // if current page is a single person view controller, zoom to that person's face
                            if let singlePersonViewController = page as? SinglePersonPageViewController {
                                
                                // print("didFinishAnimating: \(viewControllerIndex)")
                                // zoomingActionTaker.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
                                //DispatchQueue.main.async {
                                zoomingActionTaker.zoom(to: singlePersonViewController.identification.face.rect, animated: true)
                                //                            zoomingActionTaker.zoomableImageView.zoom(to: singlePersonViewController.identification.face.rect, with: 0.8, animated: true)
                                //}
                                
                                
                                //sleep(2)
                                print("gw: scroll one face")
                            }
                        })
                        
                        
                        
                        
                    }
                })
                
                

                // sleep in the background thread should be ok
                sleep(10)
                gw_log("gw: scroll one photo")

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
