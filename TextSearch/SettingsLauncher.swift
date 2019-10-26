//
//  SettingsLauncher.swift
//  youtube
//
//  Created by Brian Voong on 6/17/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let content: String
    let imageName: String
    
    init(name: String, content: String, imageName: String) {
        self.name = name
        self.content = content
        self.imageName = imageName

    }
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var homeController: ViewController?
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
//        return [Setting(name: "Settings", imageName: "settings"), Setting(name: "Terms & privacy policy", imageName: "privacy"), Setting(name: "Send Feedback", imageName: "feedback"), Setting(name: "Help", imageName: "help"), Setting(name: "Switch Account", imageName: "switch_account"), Setting(name: "Cancel", imageName: "cancel")]
        
        return [
            Setting(name: NSLocalizedString("termPrivacyLabel", comment: ""), content: NSLocalizedString("privacyPolicyHTML", comment: ""), imageName: "privacy"),
            Setting(name: NSLocalizedString("feedbackLabel", comment: ""), content: NSLocalizedString("feedbackContentHTML", comment: ""), imageName: "feedback"),
            Setting(name: NSLocalizedString("helpLabel", comment: ""), content: NSLocalizedString("helpContentHTML", comment: ""), imageName: "help"),
            Setting(name: NSLocalizedString("cancelLabel", comment: ""), content: "", imageName: "cancel")]
    }()
    
    func showSettings() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            //handleDismissNoCompletionHandler
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissNoCompletionHandler(setting:))))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x:0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    // gw: hack to avoid relased pointer when tapping blackView
    @objc func handleDismissNoCompletionHandler(setting: Setting) {
        
         UIView.animate(withDuration: 0.5, animations: {
                   self.blackView.alpha = 0
                   
                   if let window = UIApplication.shared.keyWindow {
                       self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                   }
               }, completion: nil)
        
    }
    
    @objc func handleDismiss(setting: Setting) {
        
         UIView.animate(withDuration: 0.5, animations: {
                   self.blackView.alpha = 0
                   
                   if let window = UIApplication.shared.keyWindow {
                       self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                   }
               }, completion: { (_) in

                    
                   // TODO: below code has access err (likely the settings object is released )
                // it happens only when user tap the whitespace area
                   if setting.name != "" && setting.name != NSLocalizedString("cancelLabel", comment: "") {
                       self.homeController?.showControllerForSetting(setting: setting)
                   }
               })
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}







