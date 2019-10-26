//
//  ViewControllerConstraints.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import GoogleSignIn


// MARK: - Setup Layout constraints
extension ViewController {
    
    
    // setup the top level layout constraints and delegate subview constraint to other methods
    
    func setupLayoutConstraints() {
        
        
        
        
        // convinence vars
        guard let zoomableImageView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        
        // common to portraint and landscape
        NSLayoutConstraint.activate([
            
            
            searchView.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor, constant: 10),
            searchView.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor, constant: -10),
            searchView.topAnchor.constraint(equalTo: zoomableImageView.topAnchor, constant: 10),
            // just enough to contain content
            searchView.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),
            

            bottomViewGroup.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor, constant: -10),
            //            bottomViewGroup.centerXAnchor.constraint(equalTo: zoomableImageView.centerXAnchor),
            bottomViewGroup.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor, constant: 10),
            bottomViewGroup.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor, constant: -10)
            
            ])
        
        
        

        // top level layout constraints: 0.444 split between zoomableImageView and splitScreenView
        // portrait
        let photo_top_p = zoomableImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        photo_top_p.identifier = "photo_top_p"
        photo_top_p.isActive = false
        portraitConstraints.append(photo_top_p)
        
        // !deprecated: use fixed coll view hw ratio instead
        //        let photo_hw_ratio_p = zoomableImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,   multiplier: 1.333)
        //        photo_hw_ratio_p.identifier = "photo_hw_ratio_p"
        //        photo_hw_ratio_p.isActive = false
        //        portraitConstraints.append(photo_hw_ratio_p)
        let photo_bot_p = zoomableImageView.bottomAnchor.constraint(equalTo: splitScreenView.topAnchor)
        photo_bot_p.identifier = "photo_bot_p"
        photo_bot_p.isActive = false
        portraitConstraints.append(photo_bot_p)
        
        let photo_lead_p = zoomableImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        photo_lead_p.identifier = "photo_lead_p"
        photo_lead_p.isActive = false
        portraitConstraints.append(photo_lead_p)
        
        let photo_trail_p = zoomableImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        photo_trail_p.identifier = "photo_trail_p"
        photo_trail_p.isActive = false
        portraitConstraints.append(photo_trail_p)
        
        let splitScreenView_hw_ratio_p = splitScreenView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.444)
        splitScreenView_hw_ratio_p.identifier = "splitScreenView_hw_ratio_p"
        splitScreenView_hw_ratio_p.isActive = false
        portraitConstraints.append(splitScreenView_hw_ratio_p)
        
        
        let splitScreenView_bot_p = splitScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        splitScreenView_bot_p.identifier = "splitScreenView_bot_p"
        splitScreenView_bot_p.isActive = false
        portraitConstraints.append(splitScreenView_bot_p)
        
        let splitScreenView_lead_p = splitScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        splitScreenView_lead_p.identifier = "splitScreenView_lead_p"
        splitScreenView_lead_p.isActive = false
        portraitConstraints.append(splitScreenView_lead_p)
        
        let splitScreenView_trail_p = splitScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        splitScreenView_trail_p.identifier = "splitScreenView_trail_p"
        splitScreenView_trail_p.isActive = false
        portraitConstraints.append(splitScreenView_trail_p)
        
        // MARK: - landscape constraints
        
        let photo_top_l = zoomableImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        photo_top_l.identifier = "photo_top_l"
        photo_top_l.isActive = false
        landscapeConstraints.append(photo_top_l)
        
        let photo_bot_l = zoomableImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        photo_bot_l.identifier = "photo_bot_l"
        photo_bot_l.isActive = false
        landscapeConstraints.append(photo_bot_l)
        
        let photo_lead_l = zoomableImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        photo_lead_l.identifier = "photo_lead_l"
        photo_lead_l.isActive = false
        landscapeConstraints.append(photo_lead_l)
        
        // !deprecated: use fixed coll view hw ratio instead
        //        let photo_wh_raio_l = zoomableImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,   multiplier: 1.333)
        //        photo_wh_raio_l.identifier = "photo_wh_raio_l"
        //        photo_wh_raio_l.isActive = false
        //        landscapeConstraints.append(photo_wh_raio_l)
        let photo_trail_l = zoomableImageView.trailingAnchor.constraint(equalTo: splitScreenView.leadingAnchor)
        photo_trail_l.identifier = "photo_trail_l"
        photo_trail_l.isActive = false
        landscapeConstraints.append(photo_trail_l)
        
        let splitScreenView_top_l = splitScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        splitScreenView_top_l.identifier = "splitScreenView_top_l"
        splitScreenView_top_l.isActive = false
        landscapeConstraints.append(splitScreenView_top_l)
        
        
        let splitScreenView_bot_l = splitScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        splitScreenView_bot_l.identifier = "splitScreenView_bot_l"
        splitScreenView_bot_l.isActive = false
        landscapeConstraints.append(splitScreenView_bot_l)
        
        // !deprecated: use fixed hw ratio instead
        //        let splitScreenView_lead_l = collectionView.leadingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        //        splitScreenView_lead_l.identifier = "splitScreenView_lead_l"
        //        splitScreenView_lead_l.isActive = false
        //        landscapeConstraints.append(splitScreenView_lead_l)
        let splitScreenView_hw_ratio_l = splitScreenView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.444)
        splitScreenView_hw_ratio_l.identifier = "splitScreenView_hw_ratio_l"
        splitScreenView_hw_ratio_l.isActive = false
        landscapeConstraints.append(splitScreenView_hw_ratio_l)
        
        let splitScreenView_trail_l = splitScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        splitScreenView_trail_l.identifier = "splitScreenView_trail_l"
        splitScreenView_trail_l.isActive = false
        landscapeConstraints.append(splitScreenView_trail_l)
        
        
        // each method only sets internal constrains, organize them in a tree structure
        setupBottomViewGroupConstraints()
        setupCanvasConstraints()
        setupSplitScreenViewConstraints()
        

        setupSearchViewGroupConstraints()
        


        
    }
    
    private func setupProgressViewConstraints() {
        guard let progressView = notificationVC.view else {
            fatalError("progress view missing")
        }
        NSLayoutConstraint.activate([
            
            progressView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor)
                          
            
            ])
        
    }
    
    private func setupBottomViewGroupConstraints() {
        NSLayoutConstraint.activate([
            // in order to let superview wrap the subview's content
            bottomViewGroup.topAnchor.constraint(equalTo: menuButton.topAnchor),
            bottomViewGroup.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor),
            
            menuButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            menuButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            menuButton.centerYAnchor.constraint(equalTo: bottomViewGroup.centerYAnchor),
            menuButton.leadingAnchor.constraint(equalTo: bottomViewGroup.leadingAnchor),
            
            bannerView.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: bottomViewGroup.trailingAnchor),
//            bannerView.centerYAnchor.constraint(equalTo: bottomViewGroup.centerYAnchor)
            bannerView.topAnchor.constraint(equalTo: menuButton.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor)
            
        
        ])
    }
    
    private func setupSignStatusGroupConstraints() {
        NSLayoutConstraint.activate([
            
            
            signOutButton.widthAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_WIDTH),
            signOutButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signOutButton.centerYAnchor.constraint(equalTo: signStatusView.centerYAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: signStatusView.trailingAnchor, constant: -5),
            
            
            signInStatusText.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signInStatusText.centerYAnchor.constraint(equalTo: signStatusView.centerYAnchor),
            signInStatusText.leadingAnchor.constraint(equalTo: signStatusView.leadingAnchor, constant: 5),
            signInStatusText.trailingAnchor.constraint(equalTo: signOutButton.leadingAnchor, constant: -5),
            
            ])
    }
    
    private func setupSignInViewConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        
        
        guard let pagedView = self.detailPagedVC.view else {
            NSLog("failed to unwrap detailPagedVC")
            return
        }
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        
        // setup constraints common to portrait and landscape
        
        NSLayoutConstraint.activate([
            signInPrompt.topAnchor.constraint(equalTo: signInView.topAnchor, constant: 10),
            signInPrompt.leadingAnchor.constraint(equalTo: signInView.leadingAnchor, constant: 10),
            signInPrompt.trailingAnchor.constraint(equalTo: signInView.trailingAnchor, constant: -10),
            
            signInButton.topAnchor.constraint(equalTo: signInPrompt.bottomAnchor, constant: 10),
            signInButton.widthAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_WIDTH),
            signInButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signInButton.centerXAnchor.constraint(equalTo: signInView.centerXAnchor),
            //signInButton.centerYAnchor.constraint(equalTo: signInView.centerYAnchor),
            

            
            
            
            ])
        
        
    }
    
    
  
    
    private func setupCanvasConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: zoomableImageView.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor),
            canvas.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
            
            ])
        
        
    }
    
    // only setup the views under the named view's hierachy (i.e. setup the two sub views under splitScreenView
    private func setupSplitScreenViewConstraints() {
        NSLayoutConstraint.activate([
                detailsContainerView.topAnchor.constraint(equalTo: splitScreenView.topAnchor),
                detailsContainerView.bottomAnchor.constraint(equalTo: signStatusView.topAnchor),
                detailsContainerView.leadingAnchor.constraint(equalTo: splitScreenView.leadingAnchor),
                detailsContainerView.trailingAnchor.constraint(equalTo: splitScreenView.trailingAnchor),
                
                // top constraint is already above
                signStatusView.bottomAnchor.constraint(equalTo: splitScreenView.bottomAnchor),
                signStatusView.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT*1.2),
                signStatusView.leadingAnchor.constraint(equalTo: splitScreenView.leadingAnchor),
                signStatusView.trailingAnchor.constraint(equalTo: splitScreenView.trailingAnchor),

            

                signInView.leadingAnchor.constraint(equalTo: splitScreenView.leadingAnchor),
                signInView.trailingAnchor.constraint(equalTo: splitScreenView.trailingAnchor),
                signInView.topAnchor.constraint(equalTo: splitScreenView.topAnchor),
                signInView.bottomAnchor.constraint(equalTo: splitScreenView.bottomAnchor),
                
            
            
            ])
        
        
        // these two further splits the splitScreen in normal logged in status
        setupDetailsContainerViewConstraints()
        setupSignStatusGroupConstraints()
      
        
        // this view will cover the entire splitScreen if logged out
        setupSignInViewConstraints()
    }
    
    private func setupDetailsContainerViewConstraints() {
        
        // convinence vars
        let detailsContainerView = self.detailsContainerView
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        guard let pageView = self.detailPagedVC.view else {
            NSLog("failed to unwrap self.detailPagedVC.view ")
            return
        }
        
        // TODO: container view should split the 0.444 screen with signStatusView
        
        
        
        // coll view and paged view should fill up the container view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            
            pageView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            
            
            
            
            
            ])
        
     
          setupProgressViewConstraints()
    }
    
    
    private func setupSearchViewGroupConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        guard let pageView = self.detailPagedVC.view else {
            NSLog("failed to unwrap self.detailPagedVC.view ")
            return
        }
        
        
    
        
        
        //  camera ...... search_text ....... search_btn ........ album
        NSLayoutConstraint.activate([
            cameraButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            cameraButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            cameraButton.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            
            
            searchTextInput.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTextInput.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            // gw: let searchTextInput define the constraints to the left side, and let searchButton define the constrains to the right side
            searchTextInput.widthAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 3),
            searchTextInput.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 10),

            
            searchButton.centerYAnchor.constraint(equalTo: searchTextInput.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            // gw: let searchTextInput define the constraints to the left side, and let searchButton define the constrains to the right side
            searchButton.trailingAnchor.constraint(equalTo:albumButton.leadingAnchor,  constant: -10),
            // combine with the width ratio split defined in searchTextInput's constraints above
            searchButton.leadingAnchor.constraint(equalTo: searchTextInput.trailingAnchor, constant: 5),
            
            
            albumButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            albumButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER),
            albumButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            albumButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor)
            
            
            ])
        
        
    }
    
    
   
    
}
