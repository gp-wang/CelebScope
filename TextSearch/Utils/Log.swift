//
//  Log.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/3/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import Foundation

// logging tips: https://stackoverflow.com/questions/26913799/remove-println-for-release-version-ios-swift
func gw_log(_ msg: String) -> Void {
    #if DEBUG
    // comment out before production
    NSLog(msg)
    //NSLog("debug flag set")
    #endif
}
