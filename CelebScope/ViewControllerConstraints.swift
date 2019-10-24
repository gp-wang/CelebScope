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
        guard let zoomableImageVCView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        
        

        // top level layout constraints: 0.444 split between zoomableImageView and splitScreenView
        // portrait
        let photo_top_p = zoomableImageVCView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        photo_top_p.identifier = "photo_top_p"
        photo_top_p.isActive = false
        portraitConstraints.append(photo_top_p)
        
        // !deprecated: use fixed coll view hw ratio instead
        //        let photo_hw_ratio_p = zoomableImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,   multiplier: 1.333)
        //        photo_hw_ratio_p.identifier = "photo_hw_ratio_p"
        //        photo_hw_ratio_p.isActive = false
        //        portraitConstraints.append(photo_hw_ratio_p)
        let photo_bot_p = zoomableImageVCView.bottomAnchor.constraint(equalTo: splitScreenView.topAnchor)
        photo_bot_p.identifier = "photo_bot_p"
        photo_bot_p.isActive = false
        portraitConstraints.append(photo_bot_p)
        
        let photo_lead_p = zoomableImageVCView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        photo_lead_p.identifier = "photo_lead_p"
        photo_lead_p.isActive = false
        portraitConstraints.append(photo_lead_p)
        
        let photo_trail_p = zoomableImageVCView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        
        let photo_top_l = zoomableImageVCView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        photo_top_l.identifier = "photo_top_l"
        photo_top_l.isActive = false
        landscapeConstraints.append(photo_top_l)
        
        let photo_bot_l = zoomableImageVCView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        photo_bot_l.identifier = "photo_bot_l"
        photo_bot_l.isActive = false
        landscapeConstraints.append(photo_bot_l)
        
        let photo_lead_l = zoomableImageVCView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        photo_lead_l.identifier = "photo_lead_l"
        photo_lead_l.isActive = false
        landscapeConstraints.append(photo_lead_l)
        
        // !deprecated: use fixed coll view hw ratio instead
        //        let photo_wh_raio_l = zoomableImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,   multiplier: 1.333)
        //        photo_wh_raio_l.identifier = "photo_wh_raio_l"
        //        photo_wh_raio_l.isActive = false
        //        landscapeConstraints.append(photo_wh_raio_l)
        let photo_trail_l = zoomableImageVCView.trailingAnchor.constraint(equalTo: splitScreenView.leadingAnchor)
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
        
        

        setupCanvasConstraints()
        setupSplitScreenViewConstraints()
        setupDetailsContainerViewConstraints()

        setupButtonViewConstraints()
        setupSignInViewConstraints()
        setupBannerViewConstraints()
        setupSearchTextAndButtonConstraints()
        
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
            signInButton.widthAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_WIDTH),
            signInButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signInButton.centerXAnchor.constraint(equalTo: signInView.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: signInView.centerYAnchor),
            

            
            signOutButton.widthAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_WIDTH),
            signOutButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signOutButton.centerYAnchor.constraint(equalTo: signStatusView.centerYAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: signStatusView.trailingAnchor, constant: -10),
            

            signInStatusText.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            signInStatusText.centerYAnchor.constraint(equalTo: signStatusView.centerYAnchor),
            signInStatusText.leadingAnchor.constraint(equalTo: signStatusView.leadingAnchor, constant: 10),
            signInStatusText.trailingAnchor.constraint(equalTo: signOutButton.leadingAnchor, constant: 10),
            
            
            
            ])
        
        
        // MARK: - portrait constraints
        
        let signInView_leading_p = signInView.leadingAnchor.constraint(equalTo: pagedView.leadingAnchor)
        signInView_leading_p.identifier = "signInView_leading_p"
        signInView_leading_p.isActive = false
        portraitConstraints.append(signInView_leading_p)
        
        let signInView_trailing_p = signInView.trailingAnchor.constraint(equalTo: pagedView.trailingAnchor)
        signInView_trailing_p.identifier = "signInView_trailing_p"
        signInView_trailing_p.isActive = false
        portraitConstraints.append(signInView_trailing_p)
        
        let signInView_top_p = signInView.topAnchor.constraint(equalTo: pagedView.topAnchor)
        signInView_top_p.identifier = "signInView_top_p"
        signInView_top_p.isActive = false
        portraitConstraints.append(signInView_top_p)
        
        let signInView_bottom_p = signInView.bottomAnchor.constraint(equalTo: pagedView.bottomAnchor)
        signInView_bottom_p.identifier = "signInView_bottom_p"
        signInView_bottom_p.isActive = false
        portraitConstraints.append(signInView_bottom_p)
        
        
       
       
        
        
        
        
        // MARK: - landscape constraints
        
        let signInView_leading_l = signInView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
        signInView_leading_l.identifier = "signInView_leading_l"
        signInView_leading_l.isActive = false
        landscapeConstraints.append(signInView_leading_l)
        
        let signInView_trailing_l = signInView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        signInView_trailing_l.identifier = "signInView_trailing_l"
        signInView_trailing_l.isActive = false
        landscapeConstraints.append(signInView_trailing_l)
        
        let signInView_top_l = signInView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        signInView_top_l.identifier = "signInView_top_l"
        signInView_top_l.isActive = false
        landscapeConstraints.append(signInView_top_l)
        
        let signInView_bottom_l = signInView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        signInView_bottom_l.identifier = "signInView_bottom_l"
        signInView_bottom_l.isActive = false
        landscapeConstraints.append(signInView_bottom_l)
        
        
        
    }
    
    
    func setupBannerViewConstraints() {
        // convinence vars
        guard let zoomableImageVCView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        
        
        
        NSLayoutConstraint.activate([
           bannerView.bottomAnchor.constraint(equalTo: zoomableImageVCView.bottomAnchor, constant: -10),
//            bannerView.centerYAnchor.constraint(equalTo: self.cameraButton.centerYAnchor),
            
            bannerView.centerXAnchor.constraint(equalTo: zoomableImageVCView.centerXAnchor),
            bannerView.leadingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: self.albumButton.leadingAnchor, constant: -10)
            
            ])
    }
    
    func setupSearchTextAndButtonConstraints() {
        // convinence vars
        guard let zoomableImageVCView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        
        
        
        NSLayoutConstraint.activate([
            
            searchTextInput.centerYAnchor.constraint(equalTo: self.cameraButton.centerYAnchor),
            searchTextInput.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            //searchTextInput.centerXAnchor.constraint(equalTo: zoomableImageVCView.centerXAnchor),


            // gw: let searchTextInput define the constraints to the left side, and let searchButton define the constrains to the right side
            searchTextInput.widthAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 3),
            searchTextInput.leadingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor, constant: 10),
            //            searchTextInput.trailingAnchor.constraint(equalTo: self.albumButton.leadingAnchor, constant: -10)
            
            ])
        
        NSLayoutConstraint.activate([
            
            searchButton.centerYAnchor.constraint(equalTo: self.searchTextInput.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT),
            
            
            // gw: let searchTextInput define the constraints to the left side, and let searchButton define the constrains to the right side

            searchButton.trailingAnchor.constraint(equalTo:self.albumButton.leadingAnchor,  constant: -10),
            
            // combine with the width ratio split defined in searchTextInput's constraints above
            searchButton.leadingAnchor.constraint(equalTo: self.searchTextInput.trailingAnchor, constant: 5),
            //            searchTextInput.trailingAnchor.constraint(equalTo: self.albumButton.leadingAnchor, constant: -10)
            
            ])
    }
    
  
    
    private func setupCanvasConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        
        // MARK: - portrait constraints
        let canvas_top_p = canvas.topAnchor.constraint(equalTo: zoomableImageView.topAnchor)
        canvas_top_p.identifier = "canvas_top_p"
        canvas_top_p.isActive = false
        portraitConstraints.append(canvas_top_p)
        
        let canvas_bot_p = canvas.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
        canvas_bot_p.identifier = "canvas_bot_p"
        canvas_bot_p.isActive = false
        portraitConstraints.append(canvas_bot_p)
        
        
        let canvas_lead_p = canvas.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor)
        canvas_lead_p.identifier = "canvas_lead_p"
        canvas_lead_p.isActive = false
        portraitConstraints.append(canvas_lead_p)
        
        
        let canvas_trail_p = canvas.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        canvas_trail_p.identifier = "canvas_trail_p"
        canvas_trail_p.isActive = false
        portraitConstraints.append(canvas_trail_p)
        
        // MARK: - landscape constraints
        
        let canvas_top_l = canvas.topAnchor.constraint(equalTo: zoomableImageView.topAnchor)
        canvas_top_l.identifier = "canvas_top_l"
        canvas_top_l.isActive = false
        landscapeConstraints.append(canvas_top_l)
        
        let canvas_bot_l = canvas.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
        canvas_bot_l.identifier = "canvas_bot_l"
        canvas_bot_l.isActive = false
        landscapeConstraints.append(canvas_bot_l)
        
        let canvas_lead_l = canvas.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor)
        canvas_lead_l.identifier = "canvas_lead_l"
        canvas_lead_l.isActive = false
        landscapeConstraints.append(canvas_lead_l)
        
        let canvas_trail_l = canvas.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        canvas_trail_l.identifier = "canvas_trail_l"
        canvas_trail_l.isActive = false
        landscapeConstraints.append(canvas_trail_l)
        
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
                signStatusView.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT*1.5),
                signStatusView.leadingAnchor.constraint(equalTo: splitScreenView.leadingAnchor),
                signStatusView.trailingAnchor.constraint(equalTo: splitScreenView.trailingAnchor),

            
            
            
            
            ])
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
        
     
        
    }
    
//    private func setupPageViewConstraints() {
//
//        // convinence vars
//        let zoomableImageView = self.zoomableImageVC.zoomableImageView
//        guard let collectionView = self.peopleCollectionVC.collectionView else {
//            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
//            return
//        }
//        guard let pageView = self.detailPagedVC.view else {
//            NSLog("failed to unwrap self.detailPagedVC.view ")
//            return
//        }
//
//
//        // MARK: - portrait constraints
//        let page_top_p = pageView.topAnchor.constraint(equalTo: collectionView.topAnchor)
//        page_top_p.identifier = "page_top_p"
//        page_top_p.isActive = false
//        portraitConstraints.append(page_top_p)
//
//
//        let page_bot_p = pageView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
//        page_bot_p.identifier = "page_bot_p"
//        page_bot_p.isActive = false
//        portraitConstraints.append(page_bot_p)
//
//        let page_lead_p = pageView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
//        page_lead_p.identifier = "page_lead_p"
//        page_lead_p.isActive = false
//        portraitConstraints.append(page_lead_p)
//
//        let page_trail_p = pageView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
//        page_trail_p.identifier = "page_trail_p"
//        page_trail_p.isActive = false
//        portraitConstraints.append(page_trail_p)
//
//        // MARK: - landscape constraints
//
//        let page_top_l = pageView.topAnchor.constraint(equalTo: collectionView.topAnchor)
//        page_top_l.identifier = "page_top_l"
//        page_top_l.isActive = false
//        landscapeConstraints.append(page_top_l)
//
//
//        let page_bot_l = pageView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
//        page_bot_l.identifier = "page_bot_l"
//        page_bot_l.isActive = false
//        landscapeConstraints.append(page_bot_l)
//
//        let page_lead_l = pageView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
//        page_lead_l.identifier = "page_lead_l"
//        page_lead_l.isActive = false
//        landscapeConstraints.append(page_lead_l)
//
//        let page_trail_l = pageView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
//        page_trail_l.identifier = "page_trail_l"
//        page_trail_l.isActive = false
//        landscapeConstraints.append(page_trail_l)
//    }
    
    private func setupButtonViewConstraints() {
        
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
        
        
        // MARK: - portrait constraints
        
        let cameraButton_width_p = cameraButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        cameraButton_width_p.identifier = "cameraButton_width_p"
        cameraButton_width_p.isActive = false
        portraitConstraints.append(cameraButton_width_p)
        
        let cameraButton_height_p = cameraButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        cameraButton_height_p.identifier = "cameraButton_height_p"
        cameraButton_height_p.isActive = false
        portraitConstraints.append(cameraButton_height_p)
        
        let cameraButton_lead_p = cameraButton.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor, constant: 10)
        cameraButton_lead_p.identifier = "cameraButton_lead_p"
        cameraButton_lead_p.isActive = false
        portraitConstraints.append(cameraButton_lead_p)
        
        let cameraButton_bot_p = cameraButton.topAnchor.constraint(equalTo: zoomableImageView.topAnchor, constant: 10)
        cameraButton_bot_p.identifier = "cameraButton_bot_p"
        cameraButton_bot_p.isActive = false
        portraitConstraints.append(cameraButton_bot_p)
        
        
        let albumButton_width_p = albumButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        albumButton_width_p.identifier = "albumButton_width_p"
        albumButton_width_p.isActive = false
        portraitConstraints.append(albumButton_width_p)
        
        let albumButton_height_p = albumButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        albumButton_height_p.identifier = "albumButton_height_p"
        albumButton_height_p.isActive = false
        portraitConstraints.append(albumButton_height_p)
        
        let albumButton_trailing_p = albumButton.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor, constant: -10)
        albumButton_trailing_p.identifier = "albumButton_trailing_p"
        albumButton_trailing_p.isActive = false
        portraitConstraints.append(albumButton_trailing_p)
        
        let albumButton_bot_p = albumButton.topAnchor.constraint(equalTo: zoomableImageView.topAnchor, constant: 10)
        albumButton_bot_p.identifier = "albumButton_bot_p"
        albumButton_bot_p.isActive = false
        portraitConstraints.append(albumButton_bot_p)
        
             
        
        // MARK: - landscape constraints
        
        let cameraButton_width_l = cameraButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        cameraButton_width_l.identifier = "cameraButton_width_l"
        cameraButton_width_l.isActive = false
        landscapeConstraints.append(cameraButton_width_l)
        
        let cameraButton_height_l = cameraButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        cameraButton_height_l.identifier = "cameraButton_height_l"
        cameraButton_height_l.isActive = false
        landscapeConstraints.append(cameraButton_height_l)
        
        
        let cameraButton_lead_l = cameraButton.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor, constant: 10)
        cameraButton_lead_l.identifier = "cameraButton_lead_l"
        cameraButton_lead_l.isActive = false
        landscapeConstraints.append(cameraButton_lead_l)
        
        let cameraButton_bot_l = cameraButton.topAnchor.constraint(equalTo: zoomableImageView.topAnchor, constant: 10)
        cameraButton_bot_l.identifier = "cameraButton_bot_l"
        cameraButton_bot_l.isActive = false
        landscapeConstraints.append(cameraButton_bot_l)
        
        
        let albumButton_width_l = albumButton.widthAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        albumButton_width_l.identifier = "albumButton_width_l"
        albumButton_width_l.isActive = false
        landscapeConstraints.append(albumButton_width_l)
        
        let albumButton_height_l = albumButton.heightAnchor.constraint(equalToConstant: Constants.ROUND_BUTTON_DIAMETER)
        albumButton_height_l.identifier = "albumButton_height_l"
        albumButton_height_l.isActive = false
        landscapeConstraints.append(albumButton_height_l)
        
        let albumButton_trailing_l = albumButton.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor, constant: -10)
        albumButton_trailing_l.identifier = "albumButton_trailing_l"
        albumButton_trailing_l.isActive = false
        landscapeConstraints.append(albumButton_trailing_l)
        
        let albumButton_bot_l = albumButton.topAnchor.constraint(equalTo: zoomableImageView.topAnchor, constant: 10)
        albumButton_bot_l.identifier = "albumButton_bot_l"
        albumButton_bot_l.isActive = false
        landscapeConstraints.append(albumButton_bot_l)
    }
    
    
   
    
}
