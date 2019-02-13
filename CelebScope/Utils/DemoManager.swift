//
//  DemoManager.swift
//  CelebScope
// in chargge of demoing some preset photos when user has not selected any photo yet
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
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
    
//    unowned let zoomingActionTaker: ZoomableImageViewController
//    unowned let pagingActionTaker: PeoplePageViewController
//    unowned let  collectionVC: CollectionViewController
    // gw: needed here, otherwise will cause annotation error
    // TODO: think about moving the scroll as one method into main VC, and call it from here
    //unowned let canvas: Canvas
    
    
    //gw: use one unified handle
    unowned let actionTaker: ViewController
    
    
    
    
    init(actionTaker: ViewController) {
        
//        self.zoomingActionTaker = zoomingActionTaker
//        self.pagingActionTaker = pagingActionTaker
//        self.collectionVC = collectionVC
//        self.canvas = canvas
        
        self.actionTaker = actionTaker
        
        super.init()
        gw_log("gw: init demo mgr")
        // 1
        
        
        DispatchQueue.global(qos: .userInteractive).async  { [weak self] in
            guard let demos = self?.demos,
                let count = self?.demos.count
            else {
                gw_log("gw: error unwrapping in demo mgr")
                return
            }
            
            gw_log("starting photo showing")
            
            // init
            // set photo here

            
            // populate paged VC
            var i: Int = 0
            
            
            // process cycle
            while true {
                
                
                //gw_log("showing some photo for 2 sec ...")
                
                //scroll one page here
                let demo = demos[i]

                
                self?.actionTaker.identificationResults = demo.identifications
                self?.actionTaker.setImage(image: demo.photo)
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.period, execute: {
                    // gw: each sleep or delay should be followed by a exit check
                    if let isOn = self?.isOn {
                        if !isOn {
                            return
                        }
                    } else {
                        // gw: this is needed when self is destructed and we want to stop the photoshowing task
                        return
                    }
                    gw_log("gw: face scroll start")


                    // gw: +1 to account for summary page
                    for idx in 0..<(demo.identifications.count + 1) {
       
            
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(idx) * Constants.period), execute: {
                            // gw: each sleep should be followed by a exit check
                            if let isOn = self?.isOn {
                                if !isOn {
                                    return
                                }
                            } else {
                                // gw: this is needed when self is destructed and we want to stop the photoshowing task
                                return
                            }
                            gw_log("gw: scrolling to face \(idx)")
                            self?.actionTaker.pagingAndZoomingToFaceIndexed(at: idx)

                        })
                        
                        
                        
                        
                    }
                })
                
                

                // sleep in the background thread should be ok
                sleep(10)
                // gw: each sleep should be followed by a exit check
                if let isOn = self?.isOn {
                    if !isOn {
                        break
                    }
                } else {
                    // gw: this is needed when self is destructed and we want to stop the photoshowing task
                    break
                }
                
                
                gw_log("gw: scroll one photo")

                i = (i + 1) % count
            }
            
            // tear down
            
            // clearn identifications here
            
            
            gw_log("finished photo showing")
        }
        
       
    }
    
    
    
    
    deinit {
        gw_log("deiniting demoMenager")
        self.isOn = false
    }
    
    
    func initDemos() {
        
        
    }
    
    
}
