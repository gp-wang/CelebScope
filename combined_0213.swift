
==> ./CelebScope/ViewController.swift <==
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
        static let launchedBeforeKey: String = "launchedBefore8"
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



==> ./CelebScope/Tooltip/TooltipViewController.swift <==
//
//  TooltipVC.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/9/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import CoreGraphics


// gw: dedicated VC for the photoView
class TooltipViewController: UIViewController, UIGestureRecognizerDelegate {
    struct Constants {
        
        static let tooltipWidth: CGFloat = 200
        static let tooltipHeight: CGFloat = 80
    }
    
    
    let mainTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "1. 选择一张待查明星的相片"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    let resultTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "4. 在此查看结果。单击搜索该明星"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    let cameraButtonTooltip: UIView = {
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false

        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "2. 使用相机拍照"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .left
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                 metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    let albumButtonTooltip: UIView = {
        
        
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //container.backgroundColor = .red
        
        let _label = UILabel()
        
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "3. 使用相册选择相片"
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        _label.textColor = .white
        //_label.backgroundColor = UIColor.green
        // round corner: https://stackoverflow.com/questions/31146242/how-to-round-edges-of-uilabel-with-swift/36880682
        //_label.layer.backgroundColor = UIColor.green.cgColor
        _label.layer.backgroundColor = UIColor.clear.cgColor
        _label.layer.cornerRadius = 5
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .right
        _label.numberOfLines = 2
        
        container.addSubview(_label)
        
        let views: [String: Any] = [
            "container": container,
            "_label": _label,
            ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[_label]-15-|",
            options: [.alignAllCenterY], metrics: nil,
            views: views) + NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_label]|",
                metrics: nil,
                views: views))
        
        
        
        
        return container
        
    } ()
    
    
    // the shade to dim content below it
    let blinds: UIView = {
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = .black
        container.alpha = 0.6
        
        return container
    } ()
    
    var allConstraints = [NSLayoutConstraint] ()
    var portraitConstraints = [NSLayoutConstraint] ()
    var landscapeConstraints = [NSLayoutConstraint] ()
    
    unowned let cameraButton: UIButton
    unowned let albumButton: UIButton
    unowned let zoomableImageView: UIView
    unowned let peoplePageView: UIView
    unowned let peopleCollectionView: UIView
    
    
    
    // note: parentViewController param is needed to add subview and child
    public init(cameraButton: UIButton, albumButton: UIButton, zoomableImageView: UIView, peopleCollectionView: UIView, peoplePageView: UIView) {
        self.cameraButton = cameraButton
        self.albumButton = albumButton
        self.zoomableImageView = zoomableImageView
        self.peopleCollectionView = peopleCollectionView
        self.peoplePageView = peoplePageView
        
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.clear
        
        

        view.addSubview(blinds)
        view.addSubview(mainTooltip)
        view.addSubview(cameraButtonTooltip)
        view.addSubview(albumButtonTooltip)
        view.addSubview(resultTooltip)
        
        // gw: move this out and call separately, ONLY AFTER you added subview of parent VC
        //setupTooltipLayoutConstraints()
        
        // on tap dismiss self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip(sender:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
    }
    
    deinit {
        
        gw_log("gw: tooltip deinit")
    }
    
    @objc
    func dismissTooltip(sender: Any) {
        if let mainVC = self.parent as? ViewController {
            mainVC.tooltipVC = nil
        }
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewDidLayoutSubviews() {
        
        self.adjustLayout()
//        let bubbleLayer = CAShapeLayer()
//        let path: UIBezierPath = bubblePathForContentSize(contentSize: cameraButtonTooltip.bounds.size.applying(CGAffineTransform(scaleX: 0.3, y: 0.3)))
//            path.apply(CGAffineTransform(rotationAngle: .pi))
//        bubbleLayer.path = path.cgPath
//        bubbleLayer.fillColor = UIColor.yellow.cgColor
//        bubbleLayer.strokeColor = UIColor.blue.cgColor
//        bubbleLayer.lineWidth = borderWidth
//        bubbleLayer.position = CGPoint.zero
//        cameraButtonTooltip.layer.addSublayer(bubbleLayer)
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  
    // dialog box with arrow: https://stackoverflow.com/a/33388089/8328365
    var borderWidth : CGFloat = 4 // Should be less or equal to the `radius` property
    var radius : CGFloat = 10
    var triangleHeight : CGFloat = 15
    
//    private func bubblePathForContentSize(contentSize: CGSize) -> UIBezierPath {
//        //let rect = CGRectMake(0, 0, contentSize.width, contentSize.height).offsetBy(dx: radius, dy: radius + triangleHeight)
//        let rect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height).offsetBy(dx: radius, dy: radius + triangleHeight)
//        let path = UIBezierPath();
//        let radius2 = radius - borderWidth / 2 // RadiusaddLinetto: he border width
//
//        path.move(to: CGPoint(x: rect.maxX - triangleHeight * 2, y: rect.minY - radius2))
//        path.addLine(to: CGPoint(x: rect.maxX - triangleHeight, y: rect.minY - radius2 - triangleHeight))
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.minY), radius: radius2, startAngle: CGFloat(-M_PI_2), endAngle: 0, clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius2, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.maxY), radius: radius2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
//        path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY), radius: radius2, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI_2), clockwise: true)
//        path.close()
//
//        return path
//    }
//
    
    
    
    public func setupTooltipLayoutConstraints() {

        
        
        // MARK: - all constraints
        
        let mainTooltip_width_all = mainTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        mainTooltip_width_all.identifier = "mainTooltip_width_all"
        mainTooltip_width_all.isActive = false
        allConstraints.append(mainTooltip_width_all)
        
        let mainTooltip_height_all = mainTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        mainTooltip_height_all.identifier = "mainTooltip_height_all"
        mainTooltip_height_all.isActive = false
        allConstraints.append(mainTooltip_height_all)
        
        let mainTooltip_centerX_all = mainTooltip.centerXAnchor.constraint(equalTo: self.zoomableImageView.centerXAnchor)
        mainTooltip_centerX_all.identifier = "mainTooltip_centerX_all"
        mainTooltip_centerX_all.isActive = false
        allConstraints.append(mainTooltip_centerX_all)
        
        let mainTooltip_centerY_all = mainTooltip.centerYAnchor.constraint(equalTo: self.zoomableImageView.centerYAnchor)
        mainTooltip_centerY_all.identifier = "mainTooltip_centerY_all"
        mainTooltip_centerY_all.isActive = false
        allConstraints.append(mainTooltip_centerY_all)
        
        
        // ------
        let cameraButtonTooltip_width_all = cameraButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        cameraButtonTooltip_width_all.identifier = "cameraButtonTooltip_width_all"
        cameraButtonTooltip_width_all.isActive = false
        allConstraints.append(cameraButtonTooltip_width_all)
        
        let cameraButtonTooltip_height_all = cameraButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        cameraButtonTooltip_height_all.identifier = "cameraButtonTooltip_height_all"
        cameraButtonTooltip_height_all.isActive = false
        allConstraints.append(cameraButtonTooltip_height_all)
        
        let cameraButtonTooltip_lead_all = cameraButtonTooltip.leadingAnchor.constraint(equalTo: self.cameraButton.leadingAnchor)
        cameraButtonTooltip_lead_all.identifier = "cameraButtonTooltip_lead_all"
        cameraButtonTooltip_lead_all.isActive = false
        allConstraints.append(cameraButtonTooltip_lead_all)
        
        let cameraButtonTooltip_bot_all = cameraButtonTooltip.bottomAnchor.constraint(equalTo: self.cameraButton.topAnchor, constant: -10)
        cameraButtonTooltip_bot_all.identifier = "cameraButtonTooltip_bot_all"
        cameraButtonTooltip_bot_all.isActive = false
        allConstraints.append(cameraButtonTooltip_bot_all)
        
        
        let albumButtonTooltip_width_all = albumButtonTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        albumButtonTooltip_width_all.identifier = "albumButtonTooltip_width_all"
        albumButtonTooltip_width_all.isActive = false
        allConstraints.append(albumButtonTooltip_width_all)
        
        let albumButtonTooltip_height_all = albumButtonTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        albumButtonTooltip_height_all.identifier = "albumButtonTooltip_height_all"
        albumButtonTooltip_height_all.isActive = false
        allConstraints.append(albumButtonTooltip_height_all)
        
        let albumButtonTooltip_trailing_all = albumButtonTooltip.trailingAnchor.constraint(equalTo: self.albumButton.trailingAnchor)
        albumButtonTooltip_trailing_all.identifier = "albumButtonTooltip_trailing_all"
        albumButtonTooltip_trailing_all.isActive = false
        allConstraints.append(albumButtonTooltip_trailing_all)
        
        let albumButtonTooltip_bot_all = albumButtonTooltip.bottomAnchor.constraint(equalTo: self.albumButton.topAnchor, constant: -10)
        albumButtonTooltip_bot_all.identifier = "albumButtonTooltip_bot_all"
        albumButtonTooltip_bot_all.isActive = false
        allConstraints.append(albumButtonTooltip_bot_all)
        
        // -------------
        
        let resultTooltip_width_p = resultTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        resultTooltip_width_p.identifier = "resultTooltip_width_p"
        resultTooltip_width_p.isActive = false
        portraitConstraints.append(resultTooltip_width_p)
        
        let resultTooltip_height_p = resultTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        resultTooltip_height_p.identifier = "resultTooltip_height_p"
        resultTooltip_height_p.isActive = false
        portraitConstraints.append(resultTooltip_height_p)
        
        let resultTooltip_centerX_p = resultTooltip.centerXAnchor.constraint(equalTo: self.peoplePageView.centerXAnchor)
        resultTooltip_centerX_p.identifier = "resultTooltip_centerX_p"
        resultTooltip_centerX_p.isActive = false
        portraitConstraints.append(resultTooltip_centerX_p)
        
        let resultTooltip_centerY_p = resultTooltip.centerYAnchor.constraint(equalTo: self.peoplePageView.centerYAnchor)
        resultTooltip_centerY_p.identifier = "resultTooltip_centerY_p"
        resultTooltip_centerY_p.isActive = false
        portraitConstraints.append(resultTooltip_centerY_p)
        
        let resultTooltip_width_l = resultTooltip.widthAnchor.constraint(equalToConstant: Constants.tooltipWidth)
        resultTooltip_width_l.identifier = "resultTooltip_width_l"
        resultTooltip_width_l.isActive = false
        landscapeConstraints.append(resultTooltip_width_l)
        
        let resultTooltip_height_l = resultTooltip.heightAnchor.constraint(equalToConstant: Constants.tooltipHeight)
        resultTooltip_height_l.identifier = "resultTooltip_height_l"
        resultTooltip_height_l.isActive = false
        landscapeConstraints.append(resultTooltip_height_l)
        
        let resultTooltip_centerX_l = resultTooltip.centerXAnchor.constraint(equalTo: self.peopleCollectionView.centerXAnchor)
        resultTooltip_centerX_l.identifier = "resultTooltip_centerX_l"
        resultTooltip_centerX_l.isActive = false
        landscapeConstraints.append(resultTooltip_centerX_l)
        
        let resultTooltip_centerY_l = resultTooltip.centerYAnchor.constraint(equalTo: self.peopleCollectionView.centerYAnchor)
        resultTooltip_centerY_l.identifier = "resultTooltip_centerY_l"
        resultTooltip_centerY_l.isActive = false
        landscapeConstraints.append(resultTooltip_centerY_l)
        
        
        allConstraints += [
            blinds.topAnchor.constraint(equalTo: self.view.topAnchor),
            blinds.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            blinds.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blinds.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(allConstraints)
        
        // TODO: add landscape
    }
    
    
    public func adjustLayout() {

        
        if UIDevice.current.orientation.isLandscape {

            // gw: note: always disable previous rules first, then do enabling new rules
            // implications: if you enable new rule first, you will have a short time period with conflicting rules
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)
        
            
        } else {

            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
    
        }

    }
}

==> ./CelebScope/ViewControllerConstraints.swift <==
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
        
        let cameraButton_width_p = cameraButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        cameraButton_width_p.identifier = "cameraButton_width_p"
        cameraButton_width_p.isActive = false
        portraitConstraints.append(cameraButton_width_p)
        
        let cameraButton_height_p = cameraButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
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
        
        
        let albumButton_width_p = albumButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        albumButton_width_p.identifier = "albumButton_width_p"
        albumButton_width_p.isActive = false
        portraitConstraints.append(albumButton_width_p)
        
        let albumButton_height_p = albumButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
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
        
        // MARK: - landscape constraints
        
        let cameraButton_width_l = cameraButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        cameraButton_width_l.identifier = "cameraButton_width_l"
        cameraButton_width_l.isActive = false
        landscapeConstraints.append(cameraButton_width_l)
        
        let cameraButton_height_l = cameraButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
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
        
        
        let albumButton_width_l = albumButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        albumButton_width_l.identifier = "albumButton_width_l"
        albumButton_width_l.isActive = false
        landscapeConstraints.append(albumButton_width_l)
        
        let albumButton_height_l = albumButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
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

==> ./CelebScope/Web/WebViewController.swift <==
//
//  SearchViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/10/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController, WKUIDelegate {
    
    var initialURLRequest: URLRequest

    
     init(initialURLRequest: URLRequest) {
        self.initialURLRequest = initialURLRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(initialURLRequest)
    }}

==> ./CelebScope/Utils/UIImageViewPointConversion.swift <==
//
//  PointConversion.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/21/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// MARK: - Convert pixel point to UIImageView point
extension UIImageView {
    
    func convertPoint(fromImagePoint imagePoint: CGPoint) -> CGPoint {
        guard let imageSize = image?.size else { return CGPoint.zero }
        
        var viewPoint = imagePoint
        let viewSize = bounds.size
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch contentMode {
        case .scaleAspectFit: fallthrough
        case .scaleAspectFill:
            var scale : CGFloat = 0
            
            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            }
            else {
                scale = max(ratioX, ratioY)
            }
            
            viewPoint.x *= scale
            viewPoint.y *= scale
            
            viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0
            viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
            
        case .scaleToFill: fallthrough
        case .redraw:
            viewPoint.x *= ratioX
            viewPoint.y *= ratioY
        case .center:
            viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .top:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
        case .bottom:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
            viewPoint.y += viewSize.height - imageSize.height
        case .left:
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .right:
            viewPoint.x += viewSize.width - imageSize.width
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .topRight:
            viewPoint.x += viewSize.width - imageSize.width
        case .bottomLeft:
            viewPoint.y += viewSize.height - imageSize.height
        case .bottomRight:
            viewPoint.x += viewSize.width  - imageSize.width
            viewPoint.y += viewSize.height - imageSize.height
        case.topLeft: fallthrough
        default:
            break
        }
        
        return viewPoint
    }
    
    func convertRect(fromImageRect imageRect: CGRect) -> CGRect {
        let imageTopLeft = imageRect.origin
        let imageBottomRight = CGPoint(x: imageRect.maxX, y: imageRect.maxY)
        
        let viewTopLeft = convertPoint(fromImagePoint: imageTopLeft)
        let viewBottomRight = convertPoint(fromImagePoint: imageBottomRight)
        
        var viewRect : CGRect = .zero
        viewRect.origin = viewTopLeft
        viewRect.size = CGSize(width: abs(viewBottomRight.x - viewTopLeft.x), height: abs(viewBottomRight.y - viewTopLeft.y))
        return viewRect
    }
    
    func convertPoint(fromViewPoint viewPoint: CGPoint) -> CGPoint {
        guard let imageSize = image?.size else { return CGPoint.zero }
        
        var imagePoint = viewPoint
        let viewSize = bounds.size
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch contentMode {
        case .scaleAspectFit: fallthrough
        case .scaleAspectFill:
            var scale : CGFloat = 0
            
            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            }
            else {
                scale = max(ratioX, ratioY)
            }
            
            // Remove the x or y margin added in FitMode
            imagePoint.x -= (viewSize.width  - imageSize.width  * scale) / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0
            
            imagePoint.x /= scale;
            imagePoint.y /= scale;
            
        case .scaleToFill: fallthrough
        case .redraw:
            imagePoint.x /= ratioX
            imagePoint.y /= ratioY
        case .center:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .top:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
        case .bottom:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height);
        case .left:
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .right:
            imagePoint.x -= (viewSize.width - imageSize.width);
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .topRight:
            imagePoint.x -= (viewSize.width - imageSize.width);
        case .bottomLeft:
            imagePoint.y -= (viewSize.height - imageSize.height);
        case .bottomRight:
            imagePoint.x -= (viewSize.width - imageSize.width)
            imagePoint.y -= (viewSize.height - imageSize.height)
        case.topLeft: fallthrough
        default:
            break
        }
        
        return imagePoint
    }
    
    func convertRect(fromViewRect viewRect : CGRect) -> CGRect {
        let viewTopLeft = viewRect.origin
        let viewBottomRight = CGPoint(x: viewRect.maxX, y: viewRect.maxY)
        
        let imageTopLeft = convertPoint(fromImagePoint: viewTopLeft)
        let imageBottomRight = convertPoint(fromImagePoint: viewBottomRight)
        
        var imageRect : CGRect = .zero
        imageRect.origin = imageTopLeft
        imageRect.size = CGSize(width: abs(imageBottomRight.x - imageTopLeft.x), height: abs(imageBottomRight.y - imageTopLeft.y))
        return imageRect
    }
    
}


==> ./CelebScope/Utils/Log.swift <==
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

==> ./CelebScope/Utils/UIView+Extension.swift <==
//
//  UIView+Extension.swift
//  YT - Gradient
//
//  Created by Sean Allen on 4/26/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

==> ./CelebScope/Utils/DemoManager.swift <==
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

==> ./CelebScope/Utils/Web.swift <==
//
//  Web.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/3/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//


import Foundation
import FaceCropper

// gw: for image identification
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}



// gw: take classificationResult, see in the face.crop.success for usage example
// gw: 02032019: change to array
typealias classificationCompletionHandler = ([NSDictionary]) -> Void


//    https://stackoverflow.com/questions/24603559/store-a-closure-as-a-variable-in-swift
//    var userCompletionHandler: (Any)->Void = {
//        (arg: Any) -> Void in
//    }

// completionHandler: the handler to pass down, it is supplied at the top entry point of the nested handler call
func identifyFaces(_ faces: [Face],  completionHandler: @escaping classificationCompletionHandler ) { //gw: (!done)todo: fix this. error
    // server endpoint
    let endpoint = "http://gwhome.mynetgear.com:9999/"
    let endpointUrl = URL(string: endpoint)!
    
    var request = URLRequest(url: endpointUrl)
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let jpegDataImages = faces.map({ (face: Face) -> Data in
        guard let jpegImage = UIImage(cgImage: face.image).jpegData(compressionQuality: 1) else {
            fatalError("Could not retrieve person's photo")
        }
        
        return jpegImage
    })
    
    request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "images[]", dataItems: jpegDataImages, boundary: boundary) as Data
    
    
    fireClassificationRequest(request, completionHandler)
}


func fireClassificationRequest(_ request: URLRequest, _ completionHandler: @escaping classificationCompletionHandler) {
    // gw: completion handler: URL request
    //TODO: extract completion handlers
    URLSession.shared.dataTask(with: request){
        (data: Data?, response: URLResponse?, error: Error?) in
        
        
        guard let data = data else { return }
        guard let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String? else {
            fatalError("could not get classification result ")
        }
        // gw_log(outputStr)
        
        do {
            
            guard let peopleClassification = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                fatalError("could not parse result as json")
            }
            
            completionHandler(peopleClassification)
        } catch let error as NSError {
            gw_log(error.debugDescription)
        }
        
        
        }.resume()
}


func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}



func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, dataItems: [Data], boundary: String) -> NSData {
    
    
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString(string:"--\(boundary)\r\n")
            body.appendString(string:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string:"\(value)\r\n")
        }
    }
    
    let mimetype = "image/jpg"
    
    
    // boundary notes:
    
    // boundary #1
    //  image #1
    // bondary #2
    // image #2
    //    .... (one boundary before each image)
    
    // boundary in the very end of all images (last)
    
    for (idx, item) in dataItems.enumerated() {
        body.appendString(string:"--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(idx).jpg\"\r\n")  //TODO: might not work, then need to research how to upload a (variable) list of files/photos, https://stackoverflow.com/a/26639822/8328365
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(item)
        body.appendString(string: "\r\n")
    }
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    
    return body
}

==> ./CelebScope/Utils/Utils.swift <==
//
//  Utils.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/22/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//
import CoreGraphics
import Foundation
import UIKit
// generate an data structure to be used for drawing annotation line from face location in PhotoView to People Table view cell
func generateAnnotationPoints(_ beginPosition: CGPoint, _ endPosition: CGPoint, _ spanHoriozntally : Bool) -> [CGPoint] {
    
    if (spanHoriozntally) {
        
        // x, y of the turning point
        let y_turn = endPosition.y
        let x_turn = min(endPosition.x,
                         
                         beginPosition.x + abs(endPosition.y - beginPosition.y)
            
        )
        
        return [beginPosition
            , CGPoint(x: x_turn, y: y_turn)
            , endPosition
            
        ]
    } else {
        // x, y of the turning point
        let x_turn = endPosition.x
        let y_turn = min(endPosition.y,
                         
                         beginPosition.y + abs(endPosition.x - beginPosition.x)
            
        )
        
        return [beginPosition
            , CGPoint(x: x_turn, y: y_turn)
            , endPosition
            
        ]
    }
}

public class Utils {
    static let yearFormatter : DateFormatter = {
        
        let _formatter = DateFormatter()
        _formatter.dateFormat = "yyyy"
        return _formatter
    } ()
        
        
  

}


// MARK:  for encoding decoding image to string
// https://stackoverflow.com/a/46309421/8328365
func imageTobase64(image: UIImage) -> String {
    var base64String = ""
    
    
    if let imageData = image.jpegData(compressionQuality: 1){
        base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }

    return base64String
}

func base64ToImage(base64: String) -> UIImage {
    var img: UIImage = UIImage()
    if (!base64.isEmpty) {
        if let decodedData = Data(base64Encoded: base64 , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) as? Data {
            let decodedimage = UIImage(data: decodedData)
            img = (decodedimage as UIImage?)!
        }
        
    }
    return img
}

==> ./CelebScope/Utils/Colors.swift <==
//
//  Colors.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/10/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    
    static let brightOrange     = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let red              = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let orange           = UIColor(red: 255.0/255.0, green: 175.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    static let blue             = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let brightBlue             = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 114.0/255.0, alpha: 1.0) // gw
    static let green            = UIColor(red: 91.0/255.0, green: 197.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    static let darkGrey         = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    static let veryDarkGrey     = UIColor(red: 13.0/255.0, green: 13.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    static let lightGrey        = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    static let black            = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let white            = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}

==> ./CelebScope/Utils/Demos.swift <==
//
//  Demos.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/8/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import FaceCropper

struct Demo {
    let photo: UIImage
    let identifications: [Identification]
}

class Demos {
    public static let demos: [Demo] = {
        
        
        
        let photo0 = UIImage(imageLiteralResourceName: "demo0")
        let face0_0 = Face(boundingBox: CGRect(x: 782, y: 372, width: 190, height: 190), image: UIImage(imageLiteralResourceName: "demo0_avartar_0").cgImage!)
        let person0_0 = Person(id: 0, name: "韩梅梅", avartar: UIImage(imageLiteralResourceName: "demo0_avartar_0"), birthDate: "1990", deathDate: "2018", birthPlace: "上海", imdbId: "nm0000111", bio: "一个很有名的女影星", profession: "演员，作家，制片人")
        let face0_1 = Face(boundingBox: CGRect(x: 1000, y: 324, width: 200, height: 200), image: UIImage(imageLiteralResourceName: "demo0_avartar_1").cgImage!)
        let person0_1 = Person(id: 0, name: "李雷", avartar: UIImage(imageLiteralResourceName: "demo0_avartar_1"), birthDate: "1980", deathDate: nil, birthPlace: "北京", imdbId: "nm0000222", bio: "一个很有名的男制片人", profession: "演员，作家，制片人")
        
        
        let demo0 = Demo(photo: photo0, identifications: [
            Identification(face: face0_0, person: person0_0, confidence: 1.0),
            Identification(face: face0_1, person: person0_1, confidence: 1.0)
            ])
        
        
        let photo1 = UIImage(imageLiteralResourceName: "demo1")
        let face1_0 = Face(boundingBox: CGRect(x: 2688, y: 387, width: 387, height: 387), image: UIImage(imageLiteralResourceName: "demo1_avartar_0").cgImage!)
        let person1_0 = Person(id: 0, name: "林涛", avartar: UIImage(imageLiteralResourceName: "demo1_avartar_0"), birthDate: "1970", deathDate: "2016", birthPlace: "Neverland", imdbId: "nm0000333", bio: "有名的男演员", profession: "演员，作家，制片人")
        let face1_1 = Face(boundingBox: CGRect(x: 3545, y: 447, width: 374, height: 374), image: UIImage(imageLiteralResourceName: "demo1_avartar_1").cgImage!)
        let person1_1 = Person(id: 0, name: "魏华", avartar: UIImage(imageLiteralResourceName: "demo1_avartar_1"), birthDate: "1980", deathDate: nil, birthPlace: "Neverland", imdbId: "nm0000444", bio: "出名的剧本作家", profession: "演员，作家，制片人")
        
        
        let demo1 = Demo(photo: photo1, identifications: [
            Identification(face: face1_0, person: person1_0, confidence: 1.0),
            Identification(face: face1_1, person: person1_1, confidence: 1.0)
            ])
        
        
        
        // -------------------------
        let photo2 = UIImage(imageLiteralResourceName: "demo2")
        let face2_0 = Face(boundingBox: CGRect(x: 995, y: 296, width: 200, height: 200), image: UIImage(imageLiteralResourceName: "demo2_avartar_0").cgImage!)
        let person2_0 = Person(id: 0, name: "玛丽", avartar: UIImage(imageLiteralResourceName: "demo2_avartar_0"), birthDate: "1970", deathDate: "2016", birthPlace: "Neverland", imdbId: "nm0000333", bio: "众所周知的女影视明星", profession: "演员，作家，制片人")


        let demo2 = Demo(photo: photo2, identifications: [
            Identification(face: face2_0, person: person2_0, confidence: 1.0),
            ])
        
        return [demo0, demo1, demo2]
    } ()
    
}

==> ./CelebScope/Image/ZoomableImageViewDelegate.swift <==
//
//  ZoomableImageViewDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/28/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit

class ZoomableImageViewDelegate: NSObject, UIScrollViewDelegate {
    
    
    
    // store a reference to the object which will take the actual action
    weak var actionTaker: Canvas?
    
    // the delegator who relies on this object
    unowned let delegator: ZoomableImageView
    
    init(delegator: ZoomableImageView) {
        self.delegator = delegator
        super.init()
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // gw_log("scale factor is: \(scrollView.zoomScale)")
        return delegator.imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageView = delegator.imageView
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        guard let actionTaker = actionTaker else {return }
        //gw_log("scale factor is: \(scrollView.zoomScale)")
        // gw_log("from inside ZoomableImageViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let actionTaker = actionTaker else {return }
        //gw_log("content offset is: \(scrollView.contentOffset)")
        // gw_log("from inside ZoomableImageViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    
}

==> ./CelebScope/Image/ZoomableImageView.swift <==
import UIKit

class ZoomableImageView: UIScrollView {
    
    public struct Constants {
        
        // 0.5 is not enough for several photos
        // TODO: find a better way to set it
        // do not use constants, instead, calculate at image setting time
        //static let minimumZoomScale: CGFloat = 0.005;
        //static let maximumZoomScale: CGFloat = 6.0;
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    
    // public so that delegate can access
    public let imageView: UIImageView = {
        
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return _imageView
        
    } ()
    
    
    // zoom to rect with specified ratio
    public func zoom(to rect: CGRect, with ratio: CGFloat, animated: Bool) {
        
        let oldWidth = rect.width
        let oldHeight = rect.height
        
        let oldCenter = rect.origin.applying(CGAffineTransform(translationX: oldWidth / 2.0, y: oldHeight / 2.0))
        
        
        // gw: note, the ratio is percentation of content span that should show up in frame, so if ratio is 0.8, your newRect should be larger ( * 1/0.8) to zoom to
        
        let newWidth = rect.width / ratio
        let newHeight = rect.height / ratio
        
        
        
        let newOrigin = CGPoint(x: oldCenter.x - newWidth / 2.0,
                                y: oldCenter.y - newHeight / 2.0)
        
        let newRect = CGRect(x: newOrigin.x, y: newOrigin.y, width: newWidth, height: newHeight)
        
        
        zoom(to: newRect, animated: animated)
    }
    
   // fit image to frame
    public func fitImage() {
        guard let image = self.imageView.image else {return}
        
        let ratioWidth = self.frame.width / image.size.width
        let ratioHeight = self.frame.height / image.size.height
        
        var isVertical = false
        var scale: CGFloat = 0.0
        var offset: CGPoint = .zero
        
        if ratioHeight < ratioWidth {
            isVertical = true
            scale = ratioHeight
            
            offset = CGPoint(x: 0, y: (self.contentSize.height - self.bounds.height) / 2 )
            
        } else {
            isVertical = false
            scale = ratioWidth
            
            offset = CGPoint(x: (self.contentSize.width - self.bounds.width) / 2, y: 0 )
        }
        
      


        // reset scale and offset on each resetting of image
        self.zoomScale = scale
        
        // gw: TODO: tricky for offset
        //self.contentOffset = offset
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = self.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        
        
    }
    
    
    
     // gw: must be called to complete a setting
    // note: this imageVIew is responsible for setting the image content, but its VC must setNeedsLayout
    public func setImage(image: UIImage) {
        imageView.image = image

        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        self.contentSize = image.size
        
        // gw: note, need to be placed at VC level , not here at imageView
        // https://stackoverflow.com/a/15141367/8328365
        //setNeedsLayout()
        //layoutIfNeeded()
        //setZoomScale()
        
    }
    
    func setZoomScale() {
        
        
        let imageViewSize = imageView.bounds.size
        
        let scrollViewSize = self.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        gw_log("gw: imageViewSize: \(imageViewSize), scrollViewSize: \(scrollViewSize)")
        
        self.minimumZoomScale = min(widthScale, heightScale)
        //self.maximumZoomScale = 1.2 // allow maxmum 120% of original image size
        
        self.maximumZoomScale = 6 // allow zoom to face box
        
        // set initial zoom to fit the longer side (longer side ==> smaller scale)
        zoomScale = minimumZoomScale
        

    }
    
    
    // MARK - constructor
    init() {
        // gw: there is no super.init(), you have to use this constructor as hack
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // gw: relies on autolayout constraint later
        
        
        
        addSubview(imageView)
        
        // use auto layout
        setupLayoutConstraints()
        
        
        // the delegate instance assignment should happen at a place where
        // If one object has the responsibility for several classes's delegate (e.g. here canvas is delegate for peopleCollectionVIew, and ZoomabableImageView, because canvas is in charge of updating annotatino when either one scrolls),
        // 1. you can let the object class (canvas) subclass all these delegate protocol if these protocal has no collition (different delegate protocol), or
        // 2. if these delegate protocols collides, (e.g. here both people coll View and Zoomable Image View requires scroll view delegates), make two custom classes (so that you can implement different scroll view delegate functions within each class), and at the cavas object, instance one class each as canvas's property, and assign them as delegate each for peopleCollectionVIew, and ZoomabableImageView
        
        // moved to ViewController
        //self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    

    func setupLayoutConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false


        let img_lead = imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        img_lead.identifier = "img_lead"

        let img_trail = imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        img_trail.identifier = "img_trail"

        let img_top = imageView.topAnchor.constraint(equalTo: self.topAnchor)
        img_top.identifier = "img_top"


        let img_bot = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        img_bot.identifier = "img_bot"

        for constraint in [
            img_lead, img_trail, img_top, img_bot
            ] {
                constraint.isActive = true
        }

        self.addConstraints([
            img_lead, img_trail, img_top, img_bot
            ])

    }
    
}


// moved to ZoomableImageViewDelegate
//extension ZoomableImageView: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        // gw_log("scale factor is: \(scrollView.zoomScale)")
//        return imageView
//    }
//    
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        gw_log("scale factor is: \(scrollView.zoomScale)")
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        gw_log("content offset is: \(scrollView.contentOffset)")
//    }
//}

==> ./CelebScope/Image/ZoomableImageViewController.swift <==
//
//  ZoomableImageViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/25/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC for the photoView
class ZoomableImageViewController: UIViewController {

    let zoomableImageView  = ZoomableImageView()
    
    public init() {
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomableImageView)
        
        setupInternalLayoutConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // double tap zoom: https://www.appcoda.com/uiscrollview-introduction/
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        zoomableImageView.addGestureRecognizer(doubleTap)
    }
    
    @objc
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (zoomableImageView.zoomScale > zoomableImageView.minimumZoomScale) {
            zoomableImageView.setZoomScale(zoomableImageView.minimumZoomScale, animated: true)
        } else {
            zoomableImageView.setZoomScale(zoomableImageView.maximumZoomScale, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()  // double tap zoom: https://www.appcoda.com/uiscrollview-introduction/
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        gw_log("gw: viewWillLayoutSubviews")
        
        
        // gw: main queue make it works now:
        // https://stackoverflow.com/questions/54452127/how-to-wait-for-subview-layout-settle-down-after-the-initial-viewdidload-cycle?noredirect=1#comment95712755_54452127
        DispatchQueue.main.async {
            self.zoomableImageView.setZoomScale()
        }
        
    }
    
    public func setImage(image: UIImage)  {
        
        // delegate the imageView to set the image content
        zoomableImageView.setImage(image: image)
        
        
        // https://stackoverflow.com/a/15141367/8328365
        // but delegate the layout update responsibility inside VC ('view' is VC's view), not view
        // gw: note, need to be placed at VC level 
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    
    private func setupInternalLayoutConstraints()  {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: zoomableImageView.topAnchor),
            view.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor),
            ])
    }
    
    // zoom to rect with specified ratio
    public func zoom(to rect: CGRect, animated: Bool) {
        
       zoomableImageView.zoom(to: rect, with: ZoomableImageView.Constants.contentSpanRatio, animated: animated)
    }
}

==> ./CelebScope/Canvas/Canvas.swift <==
//
//  Canvas.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// A canvas's responsibility is to draw annotation for two delegators:
// 1. peopleCollectionView
// 2. zoomableImageView
// Therefore, it make sense to instantiate it after above two is instantiated
class Canvas : UIView {

    // dedicated two vars, because canvas has two delegate responsibilities, and both are scrollview delegate
    // strong ref
    var peopleCollectionViewDelegate: PeopleCollectionViewDelegate?
    var zoomableImageViewDelegate: ZoomableImageViewDelegate?
    
    // who delegates
    var peopleCollectionView: UICollectionView?
    var zoomableImageView: ZoomableImageView?
    
    // orientation, updated from viewController
    var isLandscape: Bool = true
    
    // 1st input stage: gets data from external
    public var identifications : [Identification]? {
        didSet {
            // process data and converts into drawing pairs
            // gw: need to wrap within main thread. (check out the other usages in scrollViewDidScroll, which is likely living in main thread
            DispatchQueue.main.async {
                self.updateAnnotation()
            }

        }
    }
    
    
    // 2nd input stage (take input from self.identifications)
    // gw: Input for draw method
    public var pairs = [(CGPoint, CGPoint)] ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//
//        let path = UIBezierPath(arcCenter: self.bounds.origin, radius: self.bounds.width, startAngle: 0, endAngle: .pi * 1.0, clockwise: true)
//        UIColor.green.setFill()
//        path.fill()
//
//        return
        
        // gw_log("inside draw")
        guard let context = UIGraphicsGetCurrentContext() else {
            NSLog("err: cannot get graphics context")
            return
            
        }
//
//        //context.setFillColor(UIColor.yellow.cgColor)
//        let aPath = UIBezierPath(arcCenter: CGPoint(x: 650, y: 700), radius: 300, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
//        //UIColor.red.setFill()
//
//
//        var bPath = aPath.reversing()
//        context.setFillColor(UIColor.yellow.cgColor)
//
////        bPath.fill()
////        bPath.stroke()
//
//        context.addPath(aPath.cgPath)
//        context.fillPath()
        

        for (startPoint, endPoint) in pairs {

            // note: if islandscape, means scroll direction is vertical
            let pathPoints = generateAnnotationPoints(startPoint, endPoint, self.isLandscape)

            
            // gw_log("generated points: \(pathPoints)")
            context.setStrokeColor(Colors.brightOrange.cgColor)
            context.setLineWidth(3)

            for (idx, point) in pathPoints.enumerated() {
                if idx == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }

            // context.addPath(aPath.cgPath)
            // context.fillPath()
            context.strokePath()


        }
    }
    
    // For passing touches from an overlay view to the views underneath,
    // https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //gw_log("Passing all touches to the next view (if any), in the view stack.")
        return false
    }
    
    
    
    
    public func updateAnnotation() {
        //TODO: need to check whether both ends are visible
        
        guard  let peopleCollectionView = peopleCollectionView,
            let zoomableImageView = zoomableImageView,
            let identifications = self.identifications,
            let collectionViewFlowLayout =  peopleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                NSLog("failed to unwrap peopleCollectionView zoomableImageView identifications  collectionViewFlowLayout")
                
                return
                
        }
        
        //DispatchQueue.main.async {
        
        
        
        self.pairs.removeAll()
        
        // gw: likely no need to place in dispatch main because at this calling time (scrollView did scroll), these frames are guaranteed to exist
        // gw: because scrolling changes visible cells, we need to do canvas.pairs update in this lifecycle as well
        
        for (i,cell) in peopleCollectionView.visibleCells.enumerated() {
            
            // assume only one section
            let index_in_all_cells = peopleCollectionView.indexPathsForVisibleItems[i].row
            
            
            // gw: working: when doing coord conversion, should each time convert CONSECUTIVELY related two views like below
            let startPoint_in_CGImage = identifications[index_in_all_cells].face.position
            let startPoint_in_UIImageView = zoomableImageView.imageView.convertPoint(fromImagePoint: startPoint_in_CGImage)
            let startPoint_in_ScrollView = zoomableImageView.imageView.convert(startPoint_in_UIImageView, to: zoomableImageView)
            // because UIImageView content mode is 1:1 here, we directly use it here
            // convert to point inside canvas (which 1:1 overlays on zoomableImageView
            let startPoint = zoomableImageView.convert(startPoint_in_ScrollView, to: self)

            
            // gw: note: NOT WORKING, when do coord conversion, should each time convert CONSECUTIVELY related two views (one step at a time, see above working example)
//            let startPoint_in_CGImage = identifications[index_in_all_cells].face.position
//            let startPoint_in_UIImageView = zoomableImageView.imageView.convertPoint(fromImagePoint: startPoint_in_CGImage)
//            let startPoint = zoomableImageView.convert(startPoint_in_UIImageView, to: self)
            
            
            var endPoint = peopleCollectionView.convert(cell.frame.origin, to: self)
            
            // translate by half the side length to point to middle point
            // flag for orientation determination
            if self.isLandscape {
                // -1 to ensure point still lies within bounds
                endPoint = endPoint.applying(CGAffineTransform(translationX: -1, y: cell.bounds.height / 2   ))
            } else {
                endPoint = endPoint.applying(CGAffineTransform(translationX: cell.bounds.width / 2 , y:  -1  ))
            }
            
            // if either endpoint not in canvas bounds, skip it
            if !(self.bounds.contains(startPoint) && self.bounds.contains(endPoint) ) {
                continue
            }
            
            
            self.pairs.append((startPoint, endPoint))
            //gw_log("pairs: \(self.pairs)")
        }
        
        self.setNeedsDisplay()
        //}
    }
    
 
    
}


// moved to dedicated class PeopleCollectionViewDelegate
//extension Canvas : UIScrollViewDelegate {
//    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
//    // here the scrollView is the people collection scrollview
//    // here the canvas is the overlaying annotation layer on top of photoView
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.updateAnnotation(scrollView: scrollView)
//    }
//
//
//
//}

==> ./CelebScope/People/PagedView/SinglePersonPageViewController.swift <==
//
//  ViewController.swift
//  pageViewBlog
//
//  Created by Paul Tangen on 1/26/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit


class SinglePersonPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private struct Constants {

        static let textColor: UIColor = .white
        
        // gw: +40.0 for the copyright label
        static let avartarContainerViewWHRatio: CGFloat = 214.0 / (317.0 + 30.0)  // default avartar ratio in imdb celeb page
        // the ratio for the image only
        static let avartarImageWHRatio: CGFloat = 214.0 / (317.0)
        
        static let avartarImageSubviewTag: Int = 100
        static let avartarCopyrightSubviewTag: Int = 200
    }
    
    
    // style for control line spacing
    static let bioLabelParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 2
        
        //        paragraphStyle.paragraphSpacing = 0
        //        paragraphStyle.paragraphSpacingBefore = 0
        //        paragraphStyle.minimumLineHeight = 0
        //        paragraphStyle.headIndent = 0
        //        paragraphStyle.tailIndent = 0
        //paragraphStyle.allowsDefaultTighteningForTruncation = true
        //paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        // https://stackoverflow.com/a/44658641/8328365
        // https://medium.com/@at_underscore/nsparagraphstyle-explained-visually-a8659d1fbd6f
        paragraphStyle.lineHeightMultiple = 0.85  // this is the key of line spacing
        //paragraphStyle.headIndent = 0
        //paragraphStyle.firstLineHeadIndent = 0
        
        
        
        return paragraphStyle
    } ()
    
    let identification: Identification
//    let labelInst = UILabel()
    
    let avartarView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        // set tag for get back later
        imageView.tag = Constants.avartarImageSubviewTag  // https://stackoverflow.com/a/28200007/8328365
        
        let copyrightLabelView = UILabel()
        copyrightLabelView.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabelView.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(10)
        copyrightLabelView.textColor = .black
        copyrightLabelView.textAlignment = .center
        copyrightLabelView.backgroundColor = .white
        copyrightLabelView.text = "© Wikipedia"
        copyrightLabelView.tag = Constants.avartarCopyrightSubviewTag
        
        containerView.addSubview(imageView)
        containerView.addSubview(copyrightLabelView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: Constants.avartarImageWHRatio),
            
            
            
            copyrightLabelView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            copyrightLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            copyrightLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            copyrightLabelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
            
            ])
        
        
        
        return containerView
    } ()
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        _label.textColor = Constants.textColor
        return _label
    } ()
    
    let professionLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .subheadline)
         _label.textColor = Constants.textColor
        return _label
    } ()
    
    let bioLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .body).withSize(16)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 4
        _label.allowsDefaultTighteningForTruncation = true
        //_label.adjustsFontSizeToFitWidth = true
//
//        _label.isUserInteractionEnabled = true
        
        _label.textAlignment = .left
         _label.textColor = Constants.textColor
        let attrString = NSMutableAttributedString(string: "...")
        attrString.addAttribute(.paragraphStyle, value: bioLabelParagraphStyle, range:NSMakeRange(0, attrString.length))

        _label.attributedText = attrString
        
        // vertical align
        // https://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel
        //_label.sizeToFit()
        
        return _label
    } ()
    
    let birthDeathDateLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
        _label.textAlignment = .right   // first line,
         _label.textColor = Constants.textColor
        return _label
    } ()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // gw: take-away: wrap inside main_q
        // https://stackoverflow.com/a/53057960/8328365
        DispatchQueue.main.async {
            self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        }
        
    }
    
    
    init(_ faceIdentification: Identification) {
        
        self.identification = faceIdentification
        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        
            
        if let avartarImageView = avartarView.viewWithTag(Constants.avartarImageSubviewTag) as? UIImageView {
            avartarImageView.image = faceIdentification.person.avartar?.copy() as? UIImage
        }
        
        nameLabel.text = faceIdentification.person.name
        
        professionLabel.text = faceIdentification.person.profession
        
        
        var bioStr : String
        if let rawBioStr = faceIdentification.person.bio {
            bioStr = rawBioStr.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } else {
            bioStr = "Not Available ..."
        }
        
        let attrString = NSMutableAttributedString(string: bioStr)
        attrString.addAttribute(.paragraphStyle, value: SinglePersonPageViewController.bioLabelParagraphStyle, range:NSMakeRange(0, attrString.length))
        
        
        bioLabel.attributedText = attrString
        // vertical align
        // https://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel
        // bioLabel.sizeToFit()
        
        var birthDeathDateStr = ""
        if let _birthDate = faceIdentification.person.birthDate {
            birthDeathDateStr = _birthDate + " - "
            if let _deathDate = faceIdentification.person.deathDate {
                birthDeathDateStr += _deathDate
            }
        }
        birthDeathDateLabel.text = birthDeathDateStr
 
        view.addSubview(avartarView)
        view.addSubview(nameLabel)
        view.addSubview(professionLabel)
        view.addSubview(bioLabel)
        view.addSubview(birthDeathDateLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(searchInternetForName(sender:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        // label
//        self.view.addSubview(labelInst)
//        labelInst.text = identification.person.name
//        labelInst.translatesAutoresizingMaskIntoConstraints = false
        
        setupInternalConstraints()
    }
    
    @objc func searchInternetForName(sender: SinglePersonPageViewController) {
        
        let name = self.identification.person.name
        
        // google
//        guard let escapedString = "http://www.google.com/search?q=\(name)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else {
//            gw_log("err preparing search url")
//            return
//        }
        
        // baidu
        // http://www.baidu.com/s?wd=关键字
        guard let escapedString = "http://www.baidu.com/s?wd=\(name)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else {
            gw_log("err preparing search url")
            return
        }
        let queryURL = URL(string:escapedString)
        let queryRequest = URLRequest(url: queryURL!)
        //webView.load(queryRequest)
        
        
        //gw_log("gw: tap detected \(self.nameLabel.text)")
        
        
        
        // gw: note, this is a tricky use of nav Controller, although SinglePersonPageVC is not directly added to nav controller
        guard let navVC = self.navigationController else {
            gw_log("err getting nav controller")
            return
        }
        
        
        
        let newViewController = WebViewController(initialURLRequest: queryRequest)
        
        DispatchQueue.main.async {
            
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInternalConstraints() {

        let views: [String: Any] = [
            "avartarView": avartarView,
            "nameLabel": nameLabel,
            "professionLabel": professionLabel,
            "bioLabel": bioLabel,
            "birthDeathDateLabel": birthDeathDateLabel
            ]
        

        
        //var avartarImageWHRatio: CGFloat = 214.0 / 317.0  // default avartar ratio in imdb celeb page
        
       
        //if let _avartarImage = avartarView.image {
        //    avartarImageWHRatio = _avartarImage.size.width / _avartarImage.size.height
        //}
        var allConstraints: [NSLayoutConstraint] = [
            
            
            
            avartarView.topAnchor.constraint(equalTo: view.topAnchor),
            avartarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avartarView.widthAnchor.constraint(equalTo: avartarView.heightAnchor, multiplier: Constants.avartarContainerViewWHRatio),
            avartarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //---- labels horizontal
            //nameLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            professionLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            //birthDeathDateLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: avartarView.trailingAnchor, constant: 20),
            
            //nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            professionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            //birthDeathDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            //---- labels vertical
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            birthDeathDateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            bioLabel.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 10),
            bioLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20), // gw: to allow multiple lines: https://stackoverflow.com/a/6518460/8328365 
            bioLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
        ]
        
      
//        let labelVerticalConstrains = NSLayoutConstraint.constraints(
//            withVisualFormat: "V:|-10-[nameLabel]-10-[professionLabel]-10-[bioLabel]-10-[birthDateLabel]-10-|",
//            metrics: nil,
//            views: views)
//        allConstraints += labelVerticalConstrains
        
        let labelHorizontalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[avartarView]-20-[nameLabel]-15-[birthDeathDateLabel]-20-|",
            metrics: nil,
            views: views)
        allConstraints += labelHorizontalConstrains


        NSLayoutConstraint.activate(allConstraints)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


==> ./CelebScope/People/PagedView/PeoplePageViewDelegate.swift <==
//
//  PeoplePageViewDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


class PeoplePageViewDelegate: NSObject, UIPageViewControllerDelegate{
    
    private struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
        
    }
    
    // store a reference to the object which will take the actual action
    // View Controller has a method to do zooming and paging together
    weak var actionTaker: ViewController?
    
    
    // the delegator who relies on this object
    unowned let delegator: PeoplePageViewController
    
    init(delegator: PeoplePageViewController) {
        self.delegator = delegator
        
        super.init()
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        gw_log("gw: swipe 1")
        // re-written in a way to easily extractable into another function
        
        // function param candidates
        guard let viewControllers = pageViewController.viewControllers as? [UIViewController] ,
            let viewControllerIndex = self.delegator.pages.index(of: viewControllers[0])
        
            else {
                
                gw_log("gw: pageViewController unwrapping error 1")
                return
        }
        gw_log("gw: swipe 2")
        self.actionTaker?.pagingAndZoomingToFaceIndexed(at: viewControllerIndex)
         gw_log("gw: swipe 3")
        
    }
}

==> ./CelebScope/People/PagedView/Pages/ViewController3.swift <==
//
//  ViewController3.swift
//  pageViewBlog
//
//  Created by Paul Tangen on 1/26/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        // label
        let labelInst = UILabel()
        self.view.addSubview(labelInst)
        labelInst.text = "Page 3"
        labelInst.translatesAutoresizingMaskIntoConstraints = false
        labelInst.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        labelInst.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

==> ./CelebScope/People/PagedView/PeoplePageViewController.swift <==
//
//  PeoplePageViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/25/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit



class PeoplePageViewController: UIPageViewController {
    
    var pageViewDelegateStrongRef: PeoplePageViewDelegate? {
        didSet {
            self.delegate = pageViewDelegateStrongRef
        }
    }
    
    var pages = [UIViewController]()
    let pageControl: UIPageControl = {
        let _pageControl = UIPageControl()
        
        // pageControl
        // gw: modified
        // self.pageControl.frame = CGRect()
        _pageControl.currentPageIndicatorTintColor = UIColor.black
        _pageControl.pageIndicatorTintColor = UIColor.lightGray
        _pageControl.numberOfPages = 0 // don't forget to update in populate()
        _pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return _pageControl
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    public func populate(identificationResults: [Identification]) {
     
        pages.removeAll()
        // overview Page
        var overviewPage = SummaryPageViewController(identificationResults.count)
        pages.append(overviewPage)
        
        // details page
        for identification in identificationResults {

            var page = SinglePersonPageViewController(identification)
            pages.append(page)
        }
        self.pageControl.numberOfPages = pages.count
        let initialPage = 0
        scrollToPage(initialPage)
        
        
    }
    
    
    public func scrollToPage(_ index: Int) {
        
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = index
    }
    
    // MARK: - Constructors
    init() {
        
        // gw: has to use this constructor because super.init() does not exists, the param here is for dummy purpose
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.dataSource = self
        //gw: moved to main VC
        //self.delegate = self

   
        
        self.view.addSubview(self.pageControl)

        self.view.translatesAutoresizingMaskIntoConstraints = false         // gw: note to add this
        
        setupInternalLayoutConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func setupInternalLayoutConstraints() {
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}


// MARK: - UIPageViewControllerDataSource
extension PeoplePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllers = self.pages as? [UIViewController], let viewControllerIndex = viewControllers.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        
        gw_log("viewControllerBefore")
        

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllers = self.pages as? [UIViewController], let viewControllerIndex = viewControllers.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        
        gw_log("viewControllerAfter")
        return nil
    }
}


// MARK: - UIPageViewControllerDelegate
// gw: moved to main View Controller because we need to act on zoomableImageView
//extension PeoplePageViewController: UIPageViewControllerDelegate {
//
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        
//        // set the pageControl.currentPage to the index of the current viewController in pages
//        if let viewControllers = pageViewController.viewControllers {
//            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
//                self.pageControl.currentPage = viewControllerIndex
//                gw_log("didFinishAnimating: \(viewControllerIndex)")
//            }
//        }
//        
//        
//    }
//}

==> ./CelebScope/People/PagedView/SummaryPageViewController.swift <==
//
//  SummaryPageViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/6/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//



import UIKit

class SummaryPageViewController: UIViewController {
    private struct Constants {
        
        static let textColor: UIColor = .white
    }
    
    let count: Int
    
    let nameLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.backgroundColor = .red
        _label.font = UIFont.preferredFont(forTextStyle: .headline)
        _label.textAlignment = .center
        _label.textColor = Constants.textColor
        return _label
    } ()
    
    init(_ count: Int) {
        
        self.count = count
        nameLabel.text = "图片中检测到\(count)张人脸"

        // gw: boilerplate
        super.init(nibName: nil, bundle: nil)
        
        
        
        view.addSubview(nameLabel)
        
        
        setupInternalConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInternalConstraints() {
        
        let views: [String: Any] = [
            "nameLabel": nameLabel
        ]
        
        var allConstraints: [NSLayoutConstraint] = [
            
        ]
        
        
        let labelVerticalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[nameLabel]-10-|",
            //options: .alignAllCenterX,
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstrains
        
        let labelHorizontalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[nameLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += labelHorizontalConstrains
        
        
        NSLayoutConstraint.activate(allConstraints)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // https://stackoverflow.com/a/53057960/8328365
        DispatchQueue.main.async {
             self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        }
       
    }
}


==> ./CelebScope/People/CollectionView/PeopleCollectionViewDelegate.swift <==
//
//  PeopleCollectionViewDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/28/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//
import UIKit


class PeopleCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // store a reference to the object which will take the actual action
    weak var actionTaker: Canvas?
    
    // the delegator who relies on this object
    unowned let delegator: UICollectionView
    
    init(delegator: UICollectionView) {
        self.delegator = delegator
        
        super.init()
    }
    
    
    // gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
    // here the scrollView is the people collection scrollview
    // here the canvas is the overlaying annotation layer on top of photoView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let actionTaker = actionTaker else {return }
        // gw_log("from inside PeopleCollectionViewDelegate")
        actionTaker.updateAnnotation()
    }
    
    
    
}


// MARK: - we want the width of collection cell size to always equal to collection View width, so we make collecton VC as the delegate of cell flow layout here (because the width info of colelction view can be accessed here)
// gw: looks like the sizing defined here prioritizes than the flow layout passed intot the collectionViewController
extension PeopleCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.delegator.bounds.width, height: self.delegator.bounds.width / 1.666)
    }
    
    
}

==> ./CelebScope/People/CollectionView/PersonCollectionViewCell.swift <==
//
//  PersonCollectionViewCell.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/23/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


//TODO: embed in paged VC for multiple prediction results
class PersonCollectionViewCell: UICollectionViewCell {
    
    private struct Constants {
        static let faceViewWHRatio : CGFloat = 1.0
        static let avartarViewWHRatio: CGFloat =  214.0 / 317.0
        static let textColor: UIColor = .white
    }
    
    
    // style for control line spacing
    static let nameLabelParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        //        paragraphStyle.paragraphSpacing = 0
        //        paragraphStyle.paragraphSpacingBefore = 0
        //        paragraphStyle.minimumLineHeight = 0
        //        paragraphStyle.headIndent = 0
        //        paragraphStyle.tailIndent = 0
        
        // https://stackoverflow.com/a/44658641/8328365
        paragraphStyle.lineHeightMultiple = 0.5  // this is the key of line spacing
        
        
        return paragraphStyle
    } ()
    
    var identification: Identification? {
        didSet {
            guard let _identification = self.identification else {
                gw_log("error: unwrap failed at setter")
                return
                
            }
            
            self.croppedFaceView.image = UIImage(cgImage: _identification.face.image)
            
            // avartar and confidence display logic should be grouped together, either valid photo + prob, or unknown photo + 0%
            if let _avartar = _identification.person.avartar, let _confidence = _identification.confidence as? Double {
                
                
                self.avartarView.image = _avartar
                // format to percent
                self.confidenceLabel.text = String(format: "%.0f%%", _confidence * 100.0)
            } else {
                self.avartarView.image = UIImage(imageLiteralResourceName: "unknown")
                
                self.confidenceLabel.text = "0%"
            }
            
            let attrString = NSMutableAttributedString(string: _identification.person.name)
            attrString.addAttribute(.paragraphStyle, value: PersonCollectionViewCell.nameLabelParagraphStyle, range:NSMakeRange(0, attrString.length))
        
            //self.nameLabel.text = _identification.person.name
            self.nameLabel.attributedText = attrString
          
            
        }
    }
    
    //
    let croppedFaceView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        //_imageView.backgroundColor = UIColor.green
        _imageView.backgroundColor = UIColor.clear
        _imageView.contentMode = .scaleAspectFit
        //_imageView.image = UIImage(imageLiteralResourceName: "mary")
        return _imageView
    } ()
    
    let avartarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        //imageView.image = UIImage(imageLiteralResourceName: "jlaw")
        return imageView
    } ()
    
    // gw: wrapper to center nameLabel
    let nameLabelWrapperView : UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        //_view.backgroundColor = .red
        _view.backgroundColor = .clear
        return _view
    } ()
    
    
    let nameLabel : UILabel = {
      
        let attrString = NSMutableAttributedString(string: "Jeniffer Lawrence")
        attrString.addAttribute(.paragraphStyle, value: nameLabelParagraphStyle, range:NSMakeRange(0, attrString.length))

        let _label = UILabel()
        

        _label.translatesAutoresizingMaskIntoConstraints = false
        //_label.text = "Jeniffer Lawrence"
        _label.attributedText = attrString  // for controling line spacing
        _label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(14)
        //_label.backgroundColor = UIColor.green
        _label.backgroundColor = UIColor.clear
        _label.lineBreakMode = .byWordWrapping
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.numberOfLines = 2
        _label.textColor = Constants.textColor
        //_label.backgroundColor = .red
        return _label
    } ()
    
//    let extendedPredictionLabel: UILabel = {
//        let _label = UILabel()
//        _label.translatesAutoresizingMaskIntoConstraints = false
//        _label.backgroundColor = .green
//        _label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        _label.lineBreakMode = .byWordWrapping
//        _label.numberOfLines = 5
//        return _label
//    } ()
    
    let confidenceLabel: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = .clear
        // _label.font = UIFont.preferredFont(forTextStyle: .headline)
       
     
        _label.font =   UIFont.preferredFont(forTextStyle: .headline).withSize(19)
        _label.text = "0%"
        _label.adjustsFontSizeToFitWidth = true
        _label.textColor = Constants.textColor
        return _label
    } ()
    
    // MARK: - constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(croppedFaceView)
        addSubview(nameLabelWrapperView)
        nameLabelWrapperView.addSubview(nameLabel)
        addSubview(avartarView)
        addSubview(confidenceLabel)
        
        // self.backgroundColor = UIColor(red: CGFloat(15.0/255), green: CGFloat(163.0/255), blue: CGFloat(241.0/255), alpha: 1)
        self.backgroundColor = Colors.blue
        
//        DispatchQueue.main.async {
//            self.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
//        }
        
        
        setupInternalConstraints()
    }
    
    
    // for adding gradient for autolayout
    // https://stackoverflow.com/a/39591959/8328365
    private let gradient : CAGradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [Colors.green.cgColor, Colors.blue.cgColor]
        self.gradient.startPoint = CGPoint.init(x: 1, y: 1)
        self.gradient.endPoint = CGPoint.init(x: 0, y: 0)
        if self.gradient.superlayer == nil {
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }

//    override public func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
//
//    }
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        self.layer
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupInternalConstraints() {
        let views: [String: Any] = [
            "croppedFaceView": croppedFaceView,
            "avartarView": avartarView,
            "nameLabelWrapperView": nameLabelWrapperView,
            "nameLabel": nameLabel,
            "confidenceLabel": confidenceLabel
        ]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        
        // cell constraints is done in: extension CollectionViewController: UICollectionViewDelegateFlowLayout

        // croppedFaceView
        var croppedFaceView_V = [
            croppedFaceView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            croppedFaceView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
        ]
        var croppedFaceView_H = [
            croppedFaceView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            croppedFaceView.widthAnchor.constraint(equalTo: croppedFaceView.heightAnchor, multiplier: Constants.faceViewWHRatio)
        ]
        allConstraints += croppedFaceView_V
        allConstraints += croppedFaceView_H
        
        
        // confidenceLabel
        var confidenceLabel_H = [NSLayoutConstraint]()
        confidenceLabel_H += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[croppedFaceView]-[confidenceLabel]-[avartarView]",
            metrics: nil,
            //options: []
            views: views)
        
        var confidenceLabel_V = [
            confidenceLabel.centerYAnchor.constraint(equalTo: croppedFaceView.centerYAnchor)
        ]
        allConstraints += confidenceLabel_H
        allConstraints += confidenceLabel_V
        
        // avartarView
        var avartarView_H = [NSLayoutConstraint]()
        avartarView_H += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[avartarView]-|",
            metrics: nil,
            //options: []
            views: views)
        avartarView_H += [
            avartarView.widthAnchor.constraint(equalTo: avartarView.heightAnchor, multiplier: Constants.avartarViewWHRatio)
        ]

        var avartarView_V = [NSLayoutConstraint]()
        avartarView_V += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[avartarView]-|",
            metrics: nil,
            //options: []
            views: views)
        allConstraints += avartarView_H
        allConstraints += avartarView_V
        
        
        
        // nameLabel
        var nameLabelWrapper_V = NSLayoutConstraint.constraints(
            //withVisualFormat: "V:|-[nameLabel]-|",
            withVisualFormat: "V:[croppedFaceView]-[nameLabelWrapperView]|", // gw: has to reduce padding, otherwise full name won't show
            metrics: nil,
            //options: []
            views: views)
        //        var nameLabel_H = [
        //            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
        //            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20), // gw: to allow multiple lines: https://stackoverflow.com/a/6518460/8328365
        //        ]
        var nameLabelWrapper_H = [NSLayoutConstraint]()
        nameLabelWrapper_H += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[nameLabelWrapperView]-[avartarView]",
            metrics: nil,
            //options: []
            views: views)
        

        allConstraints += nameLabelWrapper_V
        allConstraints += nameLabelWrapper_H

        var nameLabel_All = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[nameLabel]|",
            options: [.alignAllCenterY], metrics: nil,
            
            views: views)
        nameLabel_All += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[nameLabel]|", metrics: nil,
            views: views)
        
        allConstraints += nameLabel_All
        
        
        NSLayoutConstraint.activate(allConstraints)
        
        
       
    }
    
}

==> ./CelebScope/People/CollectionView/CollectionViewController.swift <==
//
//  CollectionViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/25/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC class for the person collection view
class CollectionViewController: UICollectionViewController {

     let collectionViewCellIdentifier = "MyCollectionViewCellIdentifier"
    
    var identifications: [Identification] = [] {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    
    
    
    public func populate(identifications: [Identification])  {
        
        self.identifications = identifications
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: gw: we use the implicit member "collectionView?" of UICollectionViewController
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        
        // TODO: try out
        //collectionView =  CustomUICollectionView()
        super.init(collectionViewLayout: collectionViewLayout)
        
     
        
        collectionView.backgroundColor = Colors.lightGrey
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    

}



// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath)
        
        guard let personCollectionViewCell = cell as? PersonCollectionViewCell else {
            
            gw_log("error cannot get valid collection cell, returning dummy cell")
            return cell }
        
        personCollectionViewCell.identification = self.identifications[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.identifications.count
    }
    
    
}

// gw: note, the action you want to take in this event need access the canvas, so you'd better make canvas the delegate
// MARK: - scrollView(name list) update location
//extension CollectionViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//        self.updateAnnotation()
//
//    }
//}


// MARK: - we want the width of collection cell size to always equal to collection View width, so we make collecton VC as the delegate of cell flow layout here (because the width info of colelction view can be accessed here)
// gw: looks like the sizing defines here prioritizes than the flow layout passed intot the collectionViewController
// gw: tried to move this to PeopleCollectionViewDelegate, result is working now
//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
// 
//        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.width / 1.666)
//    }
//}

==> ./CelebScope/People/Model/Identification.swift <==
//
//  Matching.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/26/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import Foundation
import FaceCropper

// a face identification result between a Face (from photo) and a Person (from your backend server known people set)
public class Identification {
    
    let face: Face
    
    // TODO: make one identification has 1 face but multiple (person, confidence) tuple list
    let person: Person
    let confidence: Double?
    
    public init(face: Face, person: Person, confidence: Double? = nil) {
        self.face = face
        self.person = person
        self.confidence = confidence
    }
    
}

==> ./CelebScope/People/Model/Person.swift <==
//
//  Person.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/26/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//
import Foundation
import UIKit

public class Person {
    let id: Int
    let name: String
    
    let avartar: UIImage?
//    let birthDate: Date?
//    let deathDate: Date?
    
    let birthDate: String?
    let deathDate: String?
    let birthPlace: String?
    let imdbId: String?
    let bio: String?
    let profession: String?
    
    // MARK: - constructors
    
//    public init(id: Int, name: String, avartar: UIImage? = nil, birthDate: Date? = nil, deathDate: Date? = nil,
    //                birthPlace: String? = nil, imdbId: String? = nil,  bio: String? = nil, profession: String? = nil) {
    public init(id: Int, name: String, avartar: UIImage? = nil, birthDate: String? = nil, deathDate: String? = nil,
                birthPlace: String? = nil, imdbId: String? = nil,  bio: String? = nil, profession: String? = nil) {
        self.id = id
        self.name = name
        self.avartar = avartar
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.birthPlace = birthPlace
        self.imdbId = imdbId
        self.bio = bio
        self.profession = profession
    }
}

==> ./CelebScope/AppDelegate.swift <==
//
//  AppDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // gw: manual set up root view controller (to replace storyboard)
//        https://www.youtube.com/watch?v=up-YD3rZeJA
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //gw: moved to VC
        //let flowLayout = UICollectionViewFlowLayout()
        // set 1 x N scroll view horizontally. (otherwise it will fold down to 2nd row)
        //flowLayout.scrollDirection = .horizontal
        
        // alternatively set this using delegate method: UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAt)
        // flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        let customCollectionViewController = ViewController()
        
//        let facesFlowLayout = FacesFlowLayout()
//        let customCollectionViewController = ViewController(collectionViewLayout: facesFlowLayout)

        
        // gw: I don't know why we need this nav VC here
        //window?.rootViewController = UINavigationController(rootViewController: customCollectionViewController)
       
        window?.rootViewController = UINavigationController(rootViewController: customCollectionViewController)
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4230599911798280~4105662515")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



==> AlbumButton.swift <==

//
//  AlbumButton.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/29/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit

class AlbumButton: UIButton {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        //        let halfWidth: CGFloat = frame.width / 2.0
        //
        //        // make button round
        //        layer.cornerRadius = halfWidth
        //        layer.borderWidth = 3
        //        layer.borderColor = UIColor.white.cgColor
        // tintColor = UIColor.white
        
        
        let image = UIImage(imageLiteralResourceName: "album") as UIImage?
        //self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        setImage(image, for: .normal)
        //imageView?.tintColor = UIColor.white
        
        //
        // addTarget(self, action: Selector("btnTouched:"), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



==> CameraButton.swift <==


//
//  CameraButton.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/29/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit

class CameraButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
//        let halfWidth: CGFloat = frame.width / 2.0
//
//        // make button round
//        layer.cornerRadius = halfWidth
//        layer.borderWidth = 3
//        layer.borderColor = UIColor.white.cgColor
        // tintColor = UIColor.white
        
        
        let image = UIImage(imageLiteralResourceName: "camera") as UIImage?
       //self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        setImage(image, for: .normal)
        //imageView?.tintColor = UIColor.white
        
        //
        // addTarget(self, action: Selector("btnTouched:"), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



==> Face.swift <==
//
//  Face.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/26/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import CoreGraphics

public class Face {
    
    // ! deprecate, reason: lets use cropped image instead of source image for separation of concern
    // the image containing entire photo ( not only the face)
    // use CGImage to be consistent with CGRect in bbox
    // let sourceImage: CGImage
    
    
    // location of face inside original Image (the group photo)
    public let rect: CGRect
    
    // the cropped face image
    public let image: CGImage
    
    
    public var position: CGPoint {
        get {
            return rect.origin.applying(CGAffineTransform(translationX: rect.width / 2.0, y: rect.height / 2.0))
        }
    }
    
    public init(boundingBox rect: CGRect, image: CGImage) {
        self.rect = rect
        self.image = image
    }
}

==> FaceCropper.swift <==



import UIKit
import Vision

public enum FaceCropResult<T> {
    case success([T])
    case notFound
    case failure(Error)
}

public struct FaceCropper<T> {
    let detectable: T
    init(_ detectable: T) {
        self.detectable = detectable
        
    }
    // gw: padding around image
    var padding : CGFloat {
        return 200
    }
    
    
    // gw: factor to leave out some backgound info around the face
    var paddingFactor: CGFloat {
        return    CGFloat(self.imageSize) / CGFloat(self.faceSize)
    }
    
    // size of the face bound box (not including surroundings)
    var faceSize: Int {
        return 160
    }
    
    // size of the image (including surroundings)
    var imageSize: Int {
        // return 182
        // return 260 // about 182 *2 / sqrt(2), plan for rotation due to face_alignment on serverside
        // gw: 12312018, changed backend to face_recog (dlib). no need margins for mtcnn or alignment, so return face region only
        return self.faceSize
    }
}

public protocol FaceCroppable {
}

public extension FaceCroppable {
    var face: FaceCropper<Self> {
        return FaceCropper(self)
    }
    
    
}


// create image with paddings
// https://stackoverflow.com/a/31240900/8328365
public extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

// resize
//    https://stackoverflow.com/a/42546027/8328365
public extension UIImage{
    
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        //        gw: skip t	he logic because we know width == height for our use case
//        let horizontalRatio = newSize.width / size.width
//        let verticalRatio = newSize.height / size.height
//
//        let ratio = max(horizontalRatio, verticalRatio)
//        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        // gw: note that scale set to 1. if 0, uses default device screen scale factor, sometimes x2, so if you want 182 sized picture, it gives 384, not what I want.
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}


func convertToPositiveModulo(_ angle_Degree: Int) -> Int {
    // angle_Degree can be any Int with open range
    var angle_within_pos_neg_360 :Int = angle_Degree % 360
    
    var angle_within_0_and_360 :Int = (angle_within_pos_neg_360 + 360 ) % 360
    
    return angle_within_0_and_360
}


public extension FaceCropper where T: CGImage {
    
    
    // !! gw: assume face bounding box is always square ( width == height)
    
    public func crop(_ completion: @escaping (FaceCropResult<Face>) -> Void, _ orientation: UIImage.Orientation) {
        
        //NSLog("gwtest: cgimage crop")
        
        guard #available(iOS 12.0, *) else {
            return
        }
        
        
        // gw: make a boundary padded version of image, for easier cropping faces with paddings near the image boundary
        
        guard let detectableUIImage:UIImage = UIImage(cgImage: self.detectable /*, scale: 1.0, orientation: orientation*/) else {
            NSLog("failed to convert cgimage to UIImage")
            return
        }
        
        guard let paddedImage:UIImage =  detectableUIImage.imageWithInsets(insets: UIEdgeInsets(top: CGFloat(self.padding), left: CGFloat(self.padding), bottom: CGFloat(self.padding), right: CGFloat(self.padding))) else {
            NSLog("failed to pad UIImage")
            return
        }
        
        
        let req = VNDetectFaceRectanglesRequest { request, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            
            //todo: what is the mtcnn leave blank percentage?
            
            //https://github.com/davidsandberg/facenet/wiki/Classifier-training-of-inception-resnet-v1
            // in facenet face cropper, 160 face boundary box is used with padded size of 182,  so face / padded_image = 160 / 182 = 0.8791 = 0.88
            let faces: [Face]? = request.results?.map({ result -> Face? in
                guard let face = result as? VNFaceObservation else { return nil }
                
                
                
                // face.roll: angle of face w.r.t. (!!IMPORTANT!!) Camera Default Orientation (home button on right) AT PHOTO TAKING TIME!!!
                // NSLog("gw: face roll is \(face.roll), image Orientation is: \(orientation.rawValue)")
                
                // dimension before scaling
                let w0 = face.boundingBox.width * CGFloat(paddedImage.cgImage!.width)
                let h0 = face.boundingBox.height * CGFloat(paddedImage.cgImage!.height)
                let x0 = face.boundingBox.origin.x * CGFloat(paddedImage.cgImage!.width)
                let y0 = (1 - face.boundingBox.origin.y) * CGFloat(paddedImage.cgImage!.height) - h0
                // center
                let c_x = x0 + w0 / 2
                let c_y = y0 + h0 / 2
                
                // gw: ensure width == height
                // use max to favor dimension with more surrounding info
                let sz = max(w0, h0)
                
                
                
                // dimension after scaling
                let w1 = sz * self.paddingFactor
                let h1 = sz * self.paddingFactor
                let x1 = c_x - w1 / 2
                let y1 = c_y - h1 / 2
                
                assert(w1 == h1, "scaled width and height should be equal")
               
                let croppingRect = CGRect(x: x1, y: y1, width: w1, height: h1)
                let faceImage = paddedImage.cgImage!.cropping(to: croppingRect)
                
                
                var faceOrientation : UIImage.Orientation
                if let faceRoll = face.roll {
                    
                    faceOrientation = faceRollToOrientation(Double(truncating: faceRoll), orientation)
                } else {
                    faceOrientation = UIImage.Orientation.up
                }
                
                guard let uiFaceImage:UIImage = UIImage(cgImage: faceImage!, scale: 1.0, orientation:  faceOrientation ) else {
                    NSLog("failed to convert cgimage to UIImage")
                    return nil
                }
                
                let resizedFaceUIImage = uiFaceImage.resizeImageWith(newSize: CGSize(width: CGFloat(self.imageSize), height: CGFloat(self.imageSize)))
                
                // translate the bbox to original image. Note: it may go below origin
                let faceBBoxInOriginalImage = croppingRect.applying(CGAffineTransform(translationX: -self.padding, y: -self.padding))
                
                return Face(boundingBox: faceBBoxInOriginalImage, image: resizedFaceUIImage.cgImage!)
            }).compactMap { $0 }
            
            guard let unwrappedFaces: [Face] = faces, unwrappedFaces.count > 0 else {
                completion(.notFound)
                return
            }
            
            completion(.success(unwrappedFaces))
        }

        
        do {
            try VNImageRequestHandler(cgImage: paddedImage.cgImage!, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
}

public extension FaceCropper where T: UIImage {
    

    func crop(_ completion: @escaping (FaceCropResult<Face>) -> Void) {
        
        
        
        guard #available(iOS 12.0, *) else {
            return
        }
        
        
        
        self.detectable.cgImage!.face.crop ({ (faceCropResult: FaceCropResult<Face>) in
            switch faceCropResult {
            //case .success(let faces: [Faces]):
            // gw: TODO; think further, why cannot specify types here
            case .success(let faces):
                completion(.success(faces))
            case .notFound:
                completion(.notFound)
            case .failure(let error):
                completion(.failure(error))
            }
        }, self.detectable.imageOrientation)
        
    }
    
}

extension NSObject: FaceCroppable {}
extension CGImage: FaceCroppable {}




func faceRollToOrientation(_ faceRollWRTPhotoViewOrientation_Radian: Double, _ photoViewOrientation: UIImage.Orientation) ->UIImage.Orientation {
    //all rotation is counter clockwise
    
    // ------section 1: get all accumulated rotation which is already applied to face ------------
    var faceRollWRTPhotoViewOrientation_Degree = Int( faceRollWRTPhotoViewOrientation_Radian * 180 / Double.pi)
    
    faceRollWRTPhotoViewOrientation_Degree = convertToPositiveModulo(faceRollWRTPhotoViewOrientation_Degree)
    
    // var rotationInTotal_Degree : Int = faceRollWRTPhotoViewOrientation_Degree
    
    
    // the already rotated angle on the photoView
    var rotationOfPhotoViewOrientation_Degree: Int
    
    if(photoViewOrientation ==  .up) {
        // photoView has been rotated by 0 degree
        rotationOfPhotoViewOrientation_Degree = 0
    } else  if (photoViewOrientation ==  .left) {
        // photoView has been rotated by 90 degree
        rotationOfPhotoViewOrientation_Degree = 90
    } else if (photoViewOrientation == .down) {
        // photoView has been rotated by 180 degree
        rotationOfPhotoViewOrientation_Degree = 180
    } else {
        // photoViewOrientation == .right
        // photoView has been rotated by 270 degree
        rotationOfPhotoViewOrientation_Degree = 270
    }
    
    var rotationInTotal_Degree : Int = faceRollWRTPhotoViewOrientation_Degree + rotationOfPhotoViewOrientation_Degree
    
    // converted angle to interval [0, 360)
    rotationInTotal_Degree = convertToPositiveModulo(rotationInTotal_Degree)
    
    
    
    // rotation digitized to one if 0, 90, 180, 270
    var digitizedRotation_Degree: Int
    
    let DEGREE_45 : Int = 45
    if (rotationInTotal_Degree <= 1 * DEGREE_45 || rotationInTotal_Degree > 7 * DEGREE_45) {
        digitizedRotation_Degree = 0
    } else if (rotationInTotal_Degree <= 3 * DEGREE_45 && rotationInTotal_Degree > 1 * DEGREE_45) {
        digitizedRotation_Degree = 90
    } else if (rotationInTotal_Degree <= 5 * DEGREE_45 && rotationInTotal_Degree > 3 * DEGREE_45) {
        digitizedRotation_Degree = 180
    } else {
        // implicitly: if (rotationInTotal_Degree <= 7 * DEGREE_45 && rotationInTotal_Degree > 5 * DEGREE_45)
        digitizedRotation_Degree = 270
    }
    
    
    // ------section 2: calculate the back rotation needed to cancel out the effect due to section 1 ------------
    // rotation needed to cancel back above total rotation degree on face
    var neededBackRotation_Degree = -digitizedRotation_Degree
    
    // normalize it to range [0, 360)
    neededBackRotation_Degree = convertToPositiveModulo(neededBackRotation_Degree)
    
    // convert the angle in Degree to Orientation
    // gw: you can think the UiOrientation as a Unit of rotation, like degree or radian
    var neededBackRotation_Orientation: UIImage.Orientation
    if(neededBackRotation_Degree == 0) {
        neededBackRotation_Orientation = .up
    } else if(neededBackRotation_Degree == 90) {
        neededBackRotation_Orientation = .left
    } else if(neededBackRotation_Degree == 180) {
        neededBackRotation_Orientation = .down
    } else {
        // implicitly:  if(neededBackRotation_Degree == 270)
        neededBackRotation_Orientation = .right
    }
    
    
    return neededBackRotation_Orientation
}


