//
//  DemoManager.swift
//  CelebScope
// in chargge of demoing some preset photos when user has not selected any photo yet
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//



import Foundation


class DemoManager: NSObject {
    
    private var isOn = true
    override init() {
        super.init()
        print("gw: init demo mgr")
        // 1
        
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            print("starting photo showing")
            
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
                
                sleep(2)
            }
            print("finished photo showing")
        }
        
    }
    
    deinit {
        print("deiniting demoMenager")
        self.isOn = false
    }
    
    
    
    
    
}
