//
//  TapOutSearchBoxDelegate.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/26/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
import UIKit
public class TapOutSearchBoxDelegate: NSObject, UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
