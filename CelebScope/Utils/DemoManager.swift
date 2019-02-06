//
//  DemoManager.swift
//  CelebScope
// in chargge of demoing some preset photos when user has not selected any photo yet
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//



import Foundation


class DemoMenager: NSObject {
    
    public var isOn = false
    
    override init() {
        super.init()
        print("gw: init demo mgr")
        // 1
        DispatchQueue.global(qos: .background).async { [weak self] in
            while true {
                
                if let isOn = self?.isOn {
                    if isOn {
                    print("showing some photo for 2 sec ...")
                    }
                }
                sleep(2)
            }
        }
        
    }
    
    
    func start() {
        self.isOn = true
    }
    
    func stop() {
        self.isOn = false
    }
    
    
    
}
