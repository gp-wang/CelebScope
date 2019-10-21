//
//  ViewControllerConstraints.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// MARK: - Setup Layout constraints
extension ViewController {
    
    func setupLayoutConstraints() {
        setupPhotoViewConstraints()
        setupCanvasConstraints()
        setupCollectionViewConstraints()
        setupPageViewConstraints()
        setupButtonViewConstraints()
        setupBannerViewConstraints()
        
    }
    
    func setupBannerViewConstraints() {
        // convinence vars
        guard let zoomableImageVCView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        
        
        
        NSLayoutConstraint.activate([
//            bannerView.bottomAnchor.constraint(equalTo: zoomableImageVCView.bottomAnchor, constant: -10),
            bannerView.centerYAnchor.constraint(equalTo: self.cameraButton.centerYAnchor),
            bannerView.centerXAnchor.constraint(equalTo: zoomableImageVCView.centerXAnchor),
            bannerView.leadingAnchor.constraint(equalTo: self.cameraButton.trailingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: self.albumButton.leadingAnchor, constant: -10)
            
            ])
    }
    
    private func setupPhotoViewConstraints() {
        
        // convinence vars
        guard let zoomableImageVCView = self.zoomableImageVC.view else {
            NSLog("failed to unwrap zoomableImageVCView")
            return
        }
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        
        // MARK: - portrait constraints
        
        
        let photo_top_p = zoomableImageVCView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        photo_top_p.identifier = "photo_top_p"
        photo_top_p.isActive = false
        portraitConstraints.append(photo_top_p)
        
        // !deprecated: use fixed coll view hw ratio instead
        //        let photo_hw_ratio_p = zoomableImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,   multiplier: 1.333)
        //        photo_hw_ratio_p.identifier = "photo_hw_ratio_p"
        //        photo_hw_ratio_p.isActive = false
        //        portraitConstraints.append(photo_hw_ratio_p)
        let photo_bot_p = zoomableImageVCView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
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
        let photo_trail_l = zoomableImageVCView.trailingAnchor.constraint(equalTo: collectionView.leadingAnchor)
        photo_trail_l.identifier = "photo_trail_l"
        photo_trail_l.isActive = false
        landscapeConstraints.append(photo_trail_l)
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
    
    private func setupCollectionViewConstraints() {
        
        // convinence vars
        let zoomableImageView = self.zoomableImageVC.zoomableImageView
        guard let collectionView = self.peopleCollectionVC.collectionView else {
            NSLog("failed to unwrap self.peopleCollectionVC.collectionView")
            return
        }
        
        // MARK: - portrait constraints
        
        // !deprecated: use fixed hw ratio instead
        //        let coll_top_p = collectionView.topAnchor.constraint(equalTo: zoomableImageView.bottomAnchor)
        //        coll_top_p.identifier = "coll_top_p"
        //        coll_top_p.isActive = false
        //        portraitConstraints.append(coll_top_p)
        let coll_hw_ratio_p = collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.444)
        coll_hw_ratio_p.identifier = "coll_hw_ratio_p"
        coll_hw_ratio_p.isActive = false
        portraitConstraints.append(coll_hw_ratio_p)
        
        
        let coll_bot_p = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        coll_bot_p.identifier = "coll_bot_p"
        coll_bot_p.isActive = false
        portraitConstraints.append(coll_bot_p)
        
        let coll_lead_p = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        coll_lead_p.identifier = "coll_lead_p"
        coll_lead_p.isActive = false
        portraitConstraints.append(coll_lead_p)
        
        let coll_trail_p = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        coll_trail_p.identifier = "coll_trail_p"
        coll_trail_p.isActive = false
        portraitConstraints.append(coll_trail_p)
        
        // MARK: - landscape constraints
        
        let coll_top_l = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        coll_top_l.identifier = "coll_top_l"
        coll_top_l.isActive = false
        landscapeConstraints.append(coll_top_l)
        
        
        let coll_bot_l = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        coll_bot_l.identifier = "coll_bot_l"
        coll_bot_l.isActive = false
        landscapeConstraints.append(coll_bot_l)
        
        // !deprecated: use fixed hw ratio instead
        //        let coll_lead_l = collectionView.leadingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor)
        //        coll_lead_l.identifier = "coll_lead_l"
        //        coll_lead_l.isActive = false
        //        landscapeConstraints.append(coll_lead_l)
        let coll_hw_ratio_l = collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.444)
        coll_hw_ratio_l.identifier = "coll_hw_ratio_l"
        coll_hw_ratio_l.isActive = false
        landscapeConstraints.append(coll_hw_ratio_l)
        
        let coll_trail_l = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        coll_trail_l.identifier = "coll_trail_l"
        coll_trail_l.isActive = false
        landscapeConstraints.append(coll_trail_l)
        
    }
    
    private func setupPageViewConstraints() {
        
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
        let page_top_p = pageView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        page_top_p.identifier = "page_top_p"
        page_top_p.isActive = false
        portraitConstraints.append(page_top_p)
        
        
        let page_bot_p = pageView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        page_bot_p.identifier = "page_bot_p"
        page_bot_p.isActive = false
        portraitConstraints.append(page_bot_p)
        
        let page_lead_p = pageView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
        page_lead_p.identifier = "page_lead_p"
        page_lead_p.isActive = false
        portraitConstraints.append(page_lead_p)
        
        let page_trail_p = pageView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        page_trail_p.identifier = "page_trail_p"
        page_trail_p.isActive = false
        portraitConstraints.append(page_trail_p)
        
        // MARK: - landscape constraints
        
        let page_top_l = pageView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        page_top_l.identifier = "page_top_l"
        page_top_l.isActive = false
        landscapeConstraints.append(page_top_l)
        
        
        let page_bot_l = pageView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        page_bot_l.identifier = "page_bot_l"
        page_bot_l.isActive = false
        landscapeConstraints.append(page_bot_l)
        
        let page_lead_l = pageView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
        page_lead_l.identifier = "page_lead_l"
        page_lead_l.isActive = false
        landscapeConstraints.append(page_lead_l)
        
        let page_trail_l = pageView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        page_trail_l.identifier = "page_trail_l"
        page_trail_l.isActive = false
        landscapeConstraints.append(page_trail_l)
    }
    
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
        
        let cameraButton_bot_p = cameraButton.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor, constant: -10)
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
        
        let albumButton_bot_p = albumButton.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor, constant: -10)
        albumButton_bot_p.identifier = "albumButton_bot_p"
        albumButton_bot_p.isActive = false
        portraitConstraints.append(albumButton_bot_p)
        
        let signInButton_width_p = signInButton.widthAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_WIDTH)
        signInButton_width_p.identifier = "signInButton_width_p"
        signInButton_width_p.isActive = false
        portraitConstraints.append( signInButton_width_p)
        
        let signInButton_height_p = signInButton.heightAnchor.constraint(equalToConstant: Constants.RECT_BUTTON_HEIGHT)
        signInButton_height_p.identifier = "signInButton_height_p"
        signInButton_height_p.isActive = false
        portraitConstraints.append(signInButton_height_p)
        
        let signInButton_centerX_p = signInButton.centerXAnchor.constraint(equalTo: zoomableImageView.centerXAnchor)
        signInButton_centerX_p.identifier = "signInButton_centerX_p"
        signInButton_centerX_p.isActive = false
        portraitConstraints.append(signInButton_centerX_p)
        
        let signInButton_centerY_p = signInButton.centerYAnchor.constraint(equalTo: zoomableImageView.centerYAnchor)
        signInButton_centerY_p.identifier = "signInButton_centerY_p"
        signInButton_centerY_p.isActive = false
        portraitConstraints.append(signInButton_centerY_p)
        
        
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
        
        let cameraButton_bot_l = cameraButton.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor, constant: -10)
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
        
        let albumButton_bot_l = albumButton.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor, constant: -10)
        albumButton_bot_l.identifier = "albumButton_bot_l"
        albumButton_bot_l.isActive = false
        landscapeConstraints.append(albumButton_bot_l)
    }
    
    
   
    
}
