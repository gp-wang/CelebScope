//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/19/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

import FaceCropper

class ViewController:  UIViewController {
    struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
        static let buttonSize: CGFloat = 60
    }
    
    // canva's VC is this main VC
    let canvas:Canvas = {
        let canvas = Canvas()
        canvas.backgroundColor = UIColor.clear
        canvas.translatesAutoresizingMaskIntoConstraints=false
        canvas.alpha = 0.2
        return canvas
    } ()
    
    
    // gw: for the person list view
    let peopleCollectionVC: CollectionViewController = {
        let _flowLayout = UICollectionViewFlowLayout()
        // set 1 x N scroll view horizontally. (otherwise it will fold down to 2nd row)
        _flowLayout.scrollDirection = .horizontal

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
    
    
    
    // MARK: - Constructor
    
    var demoManager : DemoManager? = nil
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
        
        
        // -- constraints
        
        self.setupLayoutConstraints()
        

        // buttons
        self.albumButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
       
        
        identificationResults = []
        
        self.demoManager = DemoManager(zoomingActionTaker: self.zoomableImageVC, pagingActionTaker: self.detailPagedVC)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - pick photos from album
    
    @objc func pickImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //self.addChild(imagePicker)
        //self.demoManager = DemoManager()
        self.demoManager = nil
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
           self.demoManager = nil
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // little trick to bring inherent collectionView to front
        //view.bringSubviewToFront(self.peopleCollectionVC.collectionView)
        view.bringSubviewToFront(detailPagedVC.view)
        view.bringSubviewToFront(zoomableImageVC.zoomableImageView)
        self.view.bringSubviewToFront(canvas)
        
    }
    
    // gw notes: use the correct lifecyle, instead of dispatch main
    override func viewWillLayoutSubviews() {
       
        
        // initial drawing
        self.adjustLayout()
//        
//        // gw: wait for above adjustment to finish photoView's frame
//        // TODO: can this be unwrapped?
//        DispatchQueue.main.async {
//            let image = UIImage(imageLiteralResourceName: "team")
//            self.zoomableImageVC.zoomableImageView.setImage(image: image)
//            
//            //self.updateAnnotation()
//        }
        
    }
    
    // MARK: - trait collections
    // TODO: needs more understanding and research on which appriopriate lifecycle to use
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        

        self.adjustLayout()
        //self.updateAnnotation()
        
        // need to wait for adjust layout settle
//        DispatchQueue.main.async {
//            //self.zoomableImageVC.zoomableImageView.fitImage()
//
//            self.zoomableImageVC.zoomableImageView.setZoomScale()
//        }
    }
    
    //    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    //
    //        self.adjustLayout()
    //
    //    }
    
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
            
            print("gw: adjusting to landscape")
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
            
            print("gw: adjusting to portrait")
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
            
            collectionViewFlowLayout.scrollDirection = .horizontal
            //            DispatchQueue.main.async {
            //             collectionViewFlowLayout.itemSize = CGSize(width: self.peopleCollectionVC.collectionView.bounds.height, height: self.peopleCollectionVC.collectionView.bounds.height)
            //            }
        }
        
        DispatchQueue.main.async {
            self.peopleCollectionVC.collectionView?.collectionViewLayout.invalidateLayout()
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
                
                
                
                // gw: completion handler: face classification
                // a list of known types as response, is better than using a object (unknown dict) as response type
                identifyFaces(sortedFacesByPosition,
                              completionHandler:  { (peopleClassificationResults : [NSDictionary]) in
                                
                                
                                // gw: inside completion handler, you have reference to other variable in the same scope. (closure)
                                //print(sortedFacesByPosition)
                                
                                
                                
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
                                                                                
                                                                        } (),
                                                                            birthDate: (personClassification["best"] as? NSDictionary)? ["birthYear"] as? String,
                                                                            deathDate: (personClassification["best"] as? NSDictionary)? ["deathYear"] as? String,
                                                                            bio: (personClassification["best"] as? NSDictionary)? ["bio"] as? String,
                                                                            profession: (personClassification["best"] as? NSDictionary)? ["professions"] as? String),
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
        
        
        picker.dismiss(animated: true) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                // self.configure(image: nil)

                print("picked 1")
                return
            }
            self.adjustLayout()
            // gw: needed main queue, otherwise no work
//            DispatchQueue.main.async {
                //self.zoomableImageVC.zoomableImageView.setImage(image: image)
            
            
            // gw: note, classfn of img no need to wait for zoomableImagVC to settle doen with image setting, can go in parallel
            self.zoomableImageVC.setImage(image: image)
            
            // save camera taken photo
            if picker.sourceType == .camera {
                print("Image saving 3")
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
            
            
            // put time-consuming task in the last
            self.configure(image: image)
            
            
            
  //          }
            

            //self.zoomableImageVC.zoomableImageView.fitImage()
            
            //self.peopleCollectionVC.collectionView.collectionViewLayout.invalidateLayout()

            //self.updateVisibilityOfPhotoPrompt(false)
            print("picked 2")
            //self.configure(image: image)
        }
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            //self.cleanUpForEmptyPhotoSelection()
            print("picked 3")
        }
        
    }
    
}


