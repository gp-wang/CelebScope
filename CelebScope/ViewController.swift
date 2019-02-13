//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FaceCropper

class ViewController:  UIViewController {
    struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
        static let buttonSize: CGFloat = 60
        static let launchedBeforeKey: String = "launchedBefore"
        //static let tooltipSize: CGFloat = 100
    }
    
    // canva's VC is this main VC
    let canvas:Canvas = {
        let canvas = Canvas()
        canvas.backgroundColor = UIColor.clear
        canvas.translatesAutoresizingMaskIntoConstraints=false
        canvas.alpha = 0.5
        return canvas
    } ()
    
    
    // gw: for the person list view
    let peopleCollectionVC: CollectionViewController = {
        let _flowLayout = UICollectionViewFlowLayout()
        // set 1 x N scroll view horizontally. (otherwise it will fold down to 2nd row)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)

        return CollectionViewController(collectionViewLayout: _flowLayout)
    } ()
    
    // gw: for the photo view
    let zoomableImageVC = ZoomableImageViewController()
    
    // Auto Layout
    var portraitConstraints = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    
    
    // gw: for the person details view
    let detailPagedVC = PeoplePageViewController()
    // var pages = [UIViewController]()
    // let pageControl = UIPageControl()
    
    let cameraButton = CameraButton()
    let albumButton = AlbumButton()
    
    var tooltipVC: TooltipViewController?
    
    
    var identificationResults: [Identification]  {
        didSet {
            DispatchQueue.main.async {
                // gw: updating logic for annotations etc
                self.detailPagedVC.populate(identificationResults: self.identificationResults)
                self.peopleCollectionVC.populate(identifications: self.identificationResults)
                
                self.canvas.isLandscape = UIDevice.current.orientation.isLandscape
                self.canvas.identifications = self.identificationResults
            }
            
        }
    }
    
    // let isFirstTime: Bool = false // TODO
    // https://stackoverflow.com/questions/27208103/detect-first-launch-of-ios-app
    let isFirstTime: Bool = {
        let launchedBefore = UserDefaults.standard.bool(forKey: Constants.launchedBeforeKey)
        if launchedBefore  {
            gw_log("Not first launch.")
            return false
        } else {
            gw_log("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: Constants.launchedBeforeKey)
            
            return true
        }
    } ()
    
    
    // MARK: - Constructor
    
    var demoManager : DemoManager? = nil
    
    let bannerView: GADBannerView = {
        let _bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        _bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        return _bannerView
    } ()
    //var pageViewDelegate: PeoplePageViewDelegate?
    init() {
        self.identificationResults = []
        
        super.init(nibName: nil
            , bundle: nil)
        
        // MARK: - further setup of field properties
        
        // stack views
        // gw: setting up view hierachy across multiple VC's, (should be OK per: )
        // https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/TheViewControllerHierarchy.html
        // also note we set the autolayout constraints in this main VC
        self.addChild(peopleCollectionVC)
        view.addSubview(peopleCollectionVC.view)
        
        self.addChild(zoomableImageVC)
        view.addSubview(zoomableImageVC.view)
        
        
        view.addSubview(canvas)
        
        self.addChild(detailPagedVC)
        view.addSubview(detailPagedVC.view)
        
        
        // ---------------------
        // constructing the delegatee
        let dedicatedPeopleCollectionViewDelegate = PeopleCollectionViewDelegate(delegator: peopleCollectionVC.collectionView!)
        // pd -> c: weak ref setup
        dedicatedPeopleCollectionViewDelegate.actionTaker = canvas
        // c -> pd: strong ref setup
        canvas.peopleCollectionViewDelegate = dedicatedPeopleCollectionViewDelegate
        
        // p -> pd: strong ref setup
        peopleCollectionVC.collectionView.delegate = dedicatedPeopleCollectionViewDelegate
        
        
        // ---------------------
        // constructing the delegatee
        let dedicatedZoomableImageViewDelegate = ZoomableImageViewDelegate(delegator: zoomableImageVC.zoomableImageView)
        // zd -> c: weak ref setup
        dedicatedZoomableImageViewDelegate.actionTaker = canvas
        // c -> zd: strong ref setup
        canvas.zoomableImageViewDelegate = dedicatedZoomableImageViewDelegate
        // z -> zd: strong ref setup
        zoomableImageVC.zoomableImageView.delegate = dedicatedZoomableImageViewDelegate
        
        // ---------------------
        // constructing the delegatee
        let dedicatedPageViewDelegate = PeoplePageViewDelegate(delegator: self.detailPagedVC)
        dedicatedPageViewDelegate.actionTaker = self

        // setting up at least one strong ref to avoid being GC
        self.detailPagedVC.pageViewDelegateStrongRef = dedicatedPageViewDelegate
        
        // gw: moved to setter
        // setting up the delegate
        // self.detailPagedVC.delegate = pageViewDelegateStrongRef
        
        // setting up delegate reverse ref        
        canvas.peopleCollectionView = peopleCollectionVC.collectionView
        canvas.zoomableImageView = zoomableImageVC.zoomableImageView
        
        
        
        
        // TODO:temp
        detailPagedVC.view.isHidden = true
        
        
        
        // button
        
        view.addSubview(cameraButton)
        
        
        view.addSubview(albumButton)
        
        view.addSubview(bannerView)

        
        if (isFirstTime) {
            self.tooltipVC = TooltipViewController(cameraButton: cameraButton, albumButton: albumButton, zoomableImageView: zoomableImageVC.view, peopleCollectionView: peopleCollectionVC.collectionView, peoplePageView: detailPagedVC.view)
            self.addChild(self.tooltipVC!)
            self.view.addSubview(self.tooltipVC!.view!)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.tooltipVC!.view!.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.tooltipVC!.view!.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.tooltipVC!.view!.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.tooltipVC!.view!.trailingAnchor),
                ])
            
            self.tooltipVC?.setupTooltipLayoutConstraints()
        }
        
        
        // view sequence setup
        view.bringSubviewToFront(detailPagedVC.view)
        view.bringSubviewToFront(zoomableImageVC.zoomableImageView)
        view.bringSubviewToFront(canvas)
        view.bringSubviewToFront(bannerView)
        
        
        if(isFirstTime) {
            self.view.bringSubviewToFront(tooltipVC!.view)
            self.view.bringSubviewToFront(self.cameraButton)
            self.view.bringSubviewToFront(self.albumButton)
        }
        
        
        
        // -- constraints
        
        self.setupLayoutConstraints()
        

        // buttons
        self.albumButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
       
        
        identificationResults = []
        
        self.demoManager = DemoManager(actionTaker: self)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // hide nav bar in root view VC: https://stackoverflow.com/a/2406167/8328365
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.adjustLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    
    // MARK: - pick photos from album
    
    @objc func pickImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //self.addChild(imagePicker)
        //self.demoManager = DemoManager()
       
        self.present(imagePicker, animated: true)
    }
    
    // MARK: - take photos using camera
    
    @objc func takePhoto() {
        let imagePicker = UIImagePickerController()
        //let imagePicker = UIImagePickerController() // gw: needed for the confirmation page after taking photo
        imagePicker.sourceType = .camera
        imagePicker.delegate =  self
        //self.addChild(imagePicker)
        self.present(imagePicker, animated: true)
        
        // destruct demo manager
        // self.demoManager = nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // test id: ca-app-pub-3940256099942544/2934735716
        // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        // gw: id. yanhua.wang.rz
        bannerView.adUnitID = "ca-app-pub-4230599911798280/8783274120"
        
        bannerView.rootViewController = self
        
        
        bannerView.load(GADRequest())
    }
    
    // gw notes: use the correct lifecyle, instead of dispatch main
    override func viewWillLayoutSubviews() {
       
        
        // initial drawing
        // self.adjustLayout()
//        
//        // gw: wait for above adjustment to finish photoView's frame
//        // TODO: can this be unwrapped?
//        DispatchQueue.main.async {
//            let image = UIImage(imageLiteralResourceName: "team")
//            self.zoomableImageVC.zoomableImageView.setImage(image: image)
//            
//            //self.updateAnnotation()
//        }

//        let newViewController = SearchViewController()
//
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(newViewController, animated: true)
//
//        }
    }
    
    
    // to handle rotation: https://stackoverflow.com/questions/33377708/viewwilltransitiontosize-vs-willtransitiontotraitcollection
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.adjustLayout()
    }
    
    // MARK: - trait collections
    // TODO: needs more understanding and research on which appriopriate lifecycle to use
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//
//
//        self.adjustLayout()
//        //self.updateAnnotation()
//
//        // need to wait for adjust layout settle
////        DispatchQueue.main.async {
////            //self.zoomableImageVC.zoomableImageView.fitImage()
////
////            self.zoomableImageVC.zoomableImageView.setZoomScale()
////        }
//    }
    
    //    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    //
    //        self.adjustLayout()
    //
    //    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            self.zoomableImageVC.setImage(image: image)
        }
    }
    
    public func pagingAndZoomingToFaceIndexed(at viewControllerIndex: Int) {
        // note that the viewControllerIndex == 0 corresponds to summary view page
        
        DispatchQueue.main.async {
            
            
            gw_log("gw: pagingAndZoomingToFaceIndexed 1")
            if (viewControllerIndex > self.identificationResults.count) {
                gw_log("gw: err: index is too big")
                return
            }
            
            // function body
            // set the pageControl.currentPage to the index of the current viewController in pages
            let pagingActionTaker: PeoplePageViewController = self.detailPagedVC
            let zoomingActionTaker: ZoomableImageViewController = self.zoomableImageVC
            
            // gw: note: -1 to account for the first page is summary page
            let faceIndex = viewControllerIndex - 1
            
            // page scrolling and update page control status
            gw_log("gw: pagingAndZoomingToFaceIndexed 2")
            pagingActionTaker.scrollToPage(viewControllerIndex)
            gw_log("gw: pagingAndZoomingToFaceIndexed 3")
            // if current page is a single person view controller, zoom to that person's face
            if let singlePersonViewController = pagingActionTaker.pages[viewControllerIndex ] as? SinglePersonPageViewController {
                
                // gw_log("didFinishAnimating: \(viewControllerIndex)")
                // zoomingActionTaker.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
                zoomingActionTaker.zoom(to: singlePersonViewController.identification.face.rect,  animated: true)
                gw_log("gw: pagingAndZoomingToFaceIndexed 4.1")
            } else if let summaryPageViewController = pagingActionTaker.pages[viewControllerIndex] as? SummaryPageViewController {
                // self.zoomableImageVC.zoomableImageView.zoom(to: self.zoomableImageVC.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
                zoomingActionTaker.zoomableImageView.zoom(to: zoomingActionTaker.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
                gw_log("gw: pagingAndZoomingToFaceIndexed 4.2")
            } else {
                gw_log("gw: err: unkown type of page controller in paged view ")
            }
        }
    }
    
    
    private func adjustLayout() {
        guard let collectionViewFlowLayout =  self.peopleCollectionVC.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        
        canvas.isLandscape = UIDevice.current.orientation.isLandscape
        
        // TODO: for now hide canvas unless Landscape
        canvas.isHidden = !canvas.isLandscape
        
        if UIDevice.current.orientation.isLandscape {
            self.detailPagedVC.view.isHidden = true
            self.peopleCollectionVC.view.isHidden = false
            
            gw_log("gw: adjusting to landscape")
            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)
            
            collectionViewFlowLayout.scrollDirection = .vertical
            // main queue likely needed to wait for correct size of bounds
            // gw: verified working
            //            DispatchQueue.main.async {
            //                collectionViewFlowLayout.itemSize = CGSize(width: self.peopleCollectionVC.collectionView.bounds.width, height: self.peopleCollectionVC.collectionView.bounds.width)
            //            }
            
        } else {
            self.detailPagedVC.view.isHidden = false
            self.peopleCollectionVC.view.isHidden = true
            
            gw_log("gw: adjusting to portrait")
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
            
            collectionViewFlowLayout.scrollDirection = .horizontal
            //            DispatchQueue.main.async {
            //             collectionViewFlowLayout.itemSize = CGSize(width: self.peopleCollectionVC.collectionView.bounds.height, height: self.peopleCollectionVC.collectionView.bounds.height)
            //            }
        }
        
        DispatchQueue.main.async {
            self.peopleCollectionVC.collectionView?.collectionViewLayout.invalidateLayout()
            
            //self.popTip.show(text: "Hey! Listen!", direction: .up, maxWidth: 200, in: self.view, from: self.cameraButton.frame)
            //self.popTip.show(text: "He THere", direction: .up, in: self.view, from: self.cameraButton, duration: 3000)

            //self.popTip.show(text: "test", direction: .up, maxWidth: 200, in: self.view, from: self.cameraButton, duration: 2000)
        }
    }
    
    //
    
    
    
    
}

// MARK: - face classifier
// gw: I put the classifn responsibility in main VC, instead of zoomVC, is because the later one should be only responsible for image display, not for other fn
extension ViewController {
    
    func configure(image: UIImage?) {
        guard let image = image else {
            
            gw_log("invalid image for configure/classifn")
            return
        }
        
        
        gw_log("imageOrientation: \(image.imageOrientation)")
//        gw_log("frame: \(self.photoView.frame)")
//        gw_log("bounds: \(self.photoView.bounds)")
        
        
        
        
        // gw code notes: in FaceCropper Framework, he makes all CGImage as FaceCroppable by extending them all.
        // gw: you need to import FaceCropper to let UIImage have this face property
        image.face.crop { (faceCropResult: FaceCropResult<Face>) in
            switch faceCropResult {
                //case .success(var faces: [Face]):
                // gw: type here is faces: [Face]
            // gw: TODO, read futher why cannot specify type here
            case .success(var faces):
                let epsilonY : CGFloat = 20  // gw: use an larger value to mean that if two points are close enough in this direction, then ignore it and use the ordering in the other direction
                let epsilonX : CGFloat = 0.1
                
                for face in faces{
                    gw_log("gw: found face at: \(face.position)")
                }
                
                // sort faces by their positino in photo
                // this sort is for list in ppl coll view
                // goal: less cross over from photo to ppl coll view annotations
                let sortedFacesByPosition = faces.sorted(by: { (face1: Face, face2: Face) -> Bool in
                    // gw: note, the sorting should be w.r.t. the UIView location (not original face location in cgImage)

                    // TODO: think about rotated photo or face -------------------
                    //let _p1 = self.transformPointByOrientation(face1.position, image.imageOrientation)
                    //let _p2 = self.transformPointByOrientation(face2.position, image.imageOrientation)
                    let _p1 = face1.position
                    let _p2 = face2.position


                    // gw: ordering criteria: compare y, then x (UI Kit coord, top to bottom, left to right)
                    return _p1.y - _p2.y < -epsilonY || ( _p1.y - _p2.y < epsilonY && _p1.x - _p2.x < -epsilonX)
                })
                
                // disable sort as it has bugs
                //let sortedFacesByPosition = faces
                
                
                
                // gw: completion handler: face classification
                // a list of known types as response, is better than using a object (unknown dict) as response type
                identifyFaces(sortedFacesByPosition,
                              completionHandler:  { (peopleClassificationResults : [NSDictionary]) in
                                
                                
                                // gw: inside completion handler, you have reference to other variable in the same scope. (closure)
                                //gw_log(sortedFacesByPosition)
                                
                                
                                
                                // gw: construct identificationResults from sortedFacesByPosition and peopleClassificationResults
                                var identificationResults = [Identification]()
                                
                                for (idx, (face, personClassification)) in zip(sortedFacesByPosition, peopleClassificationResults).enumerated() {
                                    let identification = Identification(face: face,
                                                                        person: Person(
                                                                            id: idx,
                                                                            name: ((personClassification["best"]
                                                                                as? NSDictionary)? ["name"]) as? String ?? "unknown",
                                                                            avartar:
                                                                            {
                                                                                guard let image_b64_str: String = (personClassification["best"] as? NSDictionary)? ["avartar"] as? String else { return nil}
                                                                                
                                                                                // https://stackoverflow.com/questions/46304641/base64-image-encoding-swift-4-ios
                                                                                return base64ToImage(base64: image_b64_str)
                                                                                
                                                                        } () ?? UIImage(imageLiteralResourceName: "unknown"),
                                                                            birthDate: (personClassification["best"] as? NSDictionary)? ["birthYear"] as? String,
                                                                            deathDate: (personClassification["best"] as? NSDictionary)? ["deathYear"] as? String,
                                                                            bio: (personClassification["best"] as? NSDictionary)? ["bio_cn"] as? String,
                                                                            //bio: String(data:((personClassification["best"] as! [String: Data]) ["bio_cn"])!, encoding: .utf8),
                                                                            
                                                                            profession: (personClassification["best"] as? NSDictionary)? ["professions_cn"] as? String),
                                                                        confidence: (personClassification["best"] as? NSDictionary)? ["prob"] as? Double
                                                                        )
                                    
                                    identificationResults.append(identification)
                                }
                                
                                // gw: updating logic is inside setter
                                self.identificationResults = identificationResults
                                
      
                })
                
            case .notFound:
                //self.showAlert("couldn't find any face")
                gw_log("cannot find any face!")
            case .failure(let error):
                //self.showAlert(error.localizedDescription)
                gw_log("failure!!!")
            }
        }
    }
}


// MARK: - image picker delegate
// gw: action after picking meage
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.demoManager = nil
        self.tooltipVC?.view.removeFromSuperview()
        self.tooltipVC?.removeFromParent()
        self.tooltipVC = nil
        gw_log("gw: img pick 1")
        picker.dismiss(animated: true) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                // self.configure(image: nil)

                //gw_log("gw: img pick picked 1")
                return
            }
            self.adjustLayout()
            // gw: needed main queue, otherwise no work
//            DispatchQueue.main.async {
                //self.zoomableImageVC.zoomableImageView.setImage(image: image)
            
            
            // gw: note, classfn of img no need to wait for zoomableImagVC to settle doen with image setting, can go in parallel
            self.setImage(image: image)
            //self.zoomableImageVC.setImage(image: image)
            
            // save camera taken photo
            if picker.sourceType == .camera {
                gw_log("Image saving 3")
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
            
            
            // put time-consuming task in the last
            self.configure(image: image)
            
            
            
  //          }
            

            //self.zoomableImageVC.zoomableImageView.fitImage()
            
            //self.peopleCollectionVC.collectionView.collectionViewLayout.invalidateLayout()

            //self.updateVisibilityOfPhotoPrompt(false)
            gw_log("picked 2")
            //self.configure(image: image)
        }
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tooltipVC?.view.removeFromSuperview()
        self.tooltipVC?.removeFromParent()
        self.tooltipVC = nil
        gw_log("gw: img pick 2")
        picker.dismiss(animated: true) {
            if let demoManager = self.demoManager {
                // let it continue demo
            } else {
                // create one
                self.demoManager = DemoManager(actionTaker: self)
            }
            
            //self.cleanUpForEmptyPhotoSelection()
            gw_log("picked 3")
        }
        
    }
    
}


