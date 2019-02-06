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
    private struct Constants {
        
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
    
    var demoManager : DemoMenager? = nil
    
    init() {
        self.identificationResults = []
        
        super.init(nibName: nil
            , bundle: nil)
        
        // MARK: - further setup of field properties
        
        detailPagedVC.delegate = self
        
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
        
        
//        let dummyCGImage = UIImage(imageLiteralResourceName: "kelly").cgImage!
//
//        identificationResults = [
//            Identification(face: Face(boundingBox: CGRect(x: 46, y: 32, width: 140, height: 140),
//                                      image: dummyCGImage.copy()!),
//                           person: Person(
//                            id: 0,
//                            name: "J.Law",
//                            avartar: UIImage(imageLiteralResourceName: "jlaw"),
//                            birthDate: Utils.yearFormatter.date(from: "1990"),
//                            bio: "Was the highest-paid actress in the world in 2015 and 2016. With her films grossing over $5.5 billion worldwide, Jennifer Lawrence is often cited as the most successful actor of her generation. She is also thus far the only person born in the 1990s to have won an acting Oscar. Jennifer Shrader Lawrence was born August 15, 1990 in Louisville, ...",
//                            profession: "Actress, Soundtrack, Producer")),
//
//            Identification(face: Face(boundingBox: CGRect(x: 215, y: 156, width: 141, height: 141),
//                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "Ellen")),
//            Identification(face: Face(boundingBox: CGRect(x: 337, y: 172, width: 187, height: 187),
//                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "The Man")),
//            Identification(face: Face(boundingBox:  CGRect(x: 524, y: 109, width: 118, height: 118),
//                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "The Other Man")),
//
//        ]
        
        
        identificationResults = []
        
    
        
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
        self.demoManager = DemoMenager()
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
        
//        DispatchQueue.main.async {
//            // reset scrollView offset. NO matter this is a nil image selection or normal image selection
//            // https://stackoverflow.com/questions/16953610/how-to-reset-my-uiscrollviews-position-after-returning-from-a-modal-transition
//            self.peopleTableView.contentOffset = CGPoint.zero
//        }
//        guard let image = image else {
//            self.cleanUpForEmptyPhotoSelection()
//
//            self.showAlert("Error: Selected image is not valid")
//            return
//        }
        
//        DispatchQueue.main.async {
//
//            self.photoView.contentMode = .scaleAspectFit
//            self.photoView.image = image    //gw: note, likely need to set contentMode first, then set image
//        }
//
        
        gw_log("imageOrientation: \(image.imageOrientation)")
//        gw_log("frame: \(self.photoView.frame)")
//        gw_log("bounds: \(self.photoView.bounds)")
        
        
        
        
        //CroppedImage(image:image.cgImage!, position: CGPoint(x: 0, y: 0))
        
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
                
                
//                let sortedPeople = sortedFacesByPosition.enumerated().map({ (index: Int, face: Face) -> Person in
//                    // TODO: confirm about scale value what to set here?
//                    // TODO: isn't imageOrientation only ready inside main queue? can we really set it here?
//                    guard let person = Person(id: index, name: "loading...", photo:  UIImage(cgImage: face.image, scale: 1, orientation: image.imageOrientation), position: face.position, desc: "loading...") else {
//
//                        fatalError("Error: could not instantiate person from detected face photo")
//
//                    }
//
//                    gw_log("position: \(face.position)")
//
//
//
//                    return person
//                })
//
//                // gw: draw cropped face before classification, for faster user interaction experience
//                // all name and desc are 'loading'
//                DispatchQueue.main.async{
//
//
//
//                    // gw: calc scale and translation to convert face location in original image to SKScene (hence UIImageView)
//                    // let trln: CGPoint = self.photoView.frame.origin
//
//                    // initial assign of rectOfAspectFittedImage. This facility is later used to calculate face locations inside photoView
//                    // This initial assigning statement is placed here right after cropping is done. (No need to wait for classification)
//                    self.rectOfAspectFittedImage =  AVMakeRect(aspectRatio: image.size, insideRect: self.photoView.frame)
//
//                    gw_log("self.photoView.frame: \(self.photoView.frame)")
//                    gw_log("rectOfAspectFittedImage: \(self.rectOfAspectFittedImage!)")
//
//
//                    self.peopleTableView.reloadData()
//
//                    // update annotation can be done right after cropping, no need to wait for classification
//
//                    do {
//                        try self.updateAnnotation(0.0)
//                    } catch {
//                        gw_log("gw unknown error: \(error)")
//                    }
//                }
                
                
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
                                
                                // e.g.
//                                identificationResults = [
//                                    Identification(face: Face(boundingBox: CGRect(x: 46, y: 32, width: 140, height: 140),
//                                                              image: dummyCGImage.copy()!),
//                                                   person: Person(
//                                                    id: 0,
//                                                    name: "J.Law",
//                                                    avartar: UIImage(imageLiteralResourceName: "jlaw"),
//                                                    birthDate: Utils.yearFormatter.date(from: "1990"),
//                                                    bio: "Was the highest-paid actress in the world in 2015 and 2016. With her films grossing over $5.5 billion worldwide, Jennifer Lawrence is often cited as the most successful actor of her generation. She is also thus far the only person born in the 1990s to have won an acting Oscar. Jennifer Shrader Lawrence was born August 15, 1990 in Louisville, ...",
//                                                    profession: "Actress, Soundtrack, Producer")),
//

//
//                                ]
//                                for person in self.people {
//
//                                    if
//                                        let classificationResult = (classificationResults[person.screenId] as? NSDictionary)
//                                            ?? (classificationResults[String(person.screenId)] as? NSDictionary),
//                                        let bestPrediction = classificationResult["best"] as? NSDictionary,
//                                        let name = bestPrediction["name"] as? String,
//                                        let prob = bestPrediction["prob"] as? Double,
//                                        var topNPredictions = classificationResult["topN"] as? [NSDictionary]
//
//                                    {
//
//                                        topNPredictions.sort(by: {
//                                            return ($0["prob"] as! Double) > ($1["prob" ] as! Double)
//                                        })
//
//
//                                        var result = ""
//                                        for dict in topNPredictions {
//
//                                            var name = dict["name"] as! String
//
//                                            if name.count > self.MAX_NAME_LEN {
//                                                let endIndex = name.index(name.startIndex, offsetBy: self.MAX_NAME_LEN - 3)
//                                                name = String(name[..<endIndex]) + "..."
//                                            }
//
//                                            var percentProb : Int = 0
//
//
//                                            if let decimalProb = dict["prob"] as? Double  {
//
//                                                percentProb = Int(decimalProb * 100)
//                                            }
//
//                                            let prob = String(format: "%3d%%", percentProb)
//                                            result += "\(prob): \(name)\n"
//
//                                        }
//
//                                        // person.name = name + " " + String(format: "%.3f", prob)
//                                        person.name = name
//                                        person.desc = "\(result)"
//
//                                    }
//                                    else  {
//                                        // fatalError("screenId \(person.screenId): could not find classification result")
//                                        gw_log("screenId \(person.screenId): could not find classification result")
//
//
//                                        // person.name = name + " " + String(format: "%.3f", prob)
//                                        person.name = "unknown"
//                                        person.desc = "unknown"
//
//                                    }
//
//
//                                }
                                
                                
                                // gw: after updating datasource, remember to reload data into VIEW!!!
                                // for UI updates in background tasks (such as completion handler in URLSession task, use main thread'dispatch queue)
                                
                                // ref: xcode documentation: Main Thread Checker
//                                DispatchQueue.main.async{
//
//                                    self.peopleTableView.reloadData()
//
//                                }
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



// MARK: - page view delegate
extension ViewController: UIPageViewControllerDelegate {
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers as? [SinglePersonPageViewController] {
            if let viewControllerIndex = self.detailPagedVC.pages.index(of: viewControllers[0]) {
                self.detailPagedVC.pageControl.currentPage = viewControllerIndex
                print("didFinishAnimating: \(viewControllerIndex)")
                self.zoomableImageVC.zoomableImageView.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
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
            self.configure(image: image)
            self.zoomableImageVC.setImage(image: image)
            
            
  //          }
            

            //self.zoomableImageVC.zoomableImageView.fitImage()
            // save camera taken photo
            if picker.sourceType == .camera {
                print("Image saving 3")
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
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




// MARK: - Setup Layout constraints
extension ViewController {
    
    private func setupLayoutConstraints() {
        setupPhotoViewConstraints()
        setupCanvasConstraints()
        setupCollectionViewConstraints()
        setupPageViewConstraints()
        setupButtonViewConstraints()
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
