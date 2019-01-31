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
        canvas.backgroundColor = UIColor.black
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
    
    var identificationResults: [Identification] = []
    
    
    
    // MARK: - Constructor
    
    init() {
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
        
        
        // -- dummy
        
        // manually marked face bbox in team.jpg
        var faces : [CGRect] = [
            CGRect(x: 46, y: 32, width: 140, height: 140), // Jeniffer Lawrence
            CGRect(x: 215, y: 156, width: 141, height: 141), // Ellen
            CGRect(x: 337, y: 172, width: 187, height: 187), // the Man
            CGRect(x: 524, y: 109, width: 118, height: 118), // the other Man
            
        ]
        
        let dummyCGImage = UIImage(imageLiteralResourceName: "kelly").cgImage!
        
        identificationResults = [
            Identification(face: Face(boundingBox: CGRect(x: 46, y: 32, width: 140, height: 140),
                                      image: dummyCGImage.copy()!),
                           person: Person(
                            id: 0,
                            name: "J.Law",
                            avartar: UIImage(imageLiteralResourceName: "jlaw"),
                            birthDate: Utils.yearFormatter.date(from: "1990"),
                            bio: "Was the highest-paid actress in the world in 2015 and 2016. With her films grossing over $5.5 billion worldwide, Jennifer Lawrence is often cited as the most successful actor of her generation. She is also thus far the only person born in the 1990s to have won an acting Oscar. Jennifer Shrader Lawrence was born August 15, 1990 in Louisville, ...",
                            profession: "Actress, Soundtrack, Producer")),
            
            Identification(face: Face(boundingBox: CGRect(x: 215, y: 156, width: 141, height: 141),
                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "Ellen")),
            Identification(face: Face(boundingBox: CGRect(x: 337, y: 172, width: 187, height: 187),
                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "The Man")),
            Identification(face: Face(boundingBox:  CGRect(x: 524, y: 109, width: 118, height: 118),
                                      image: dummyCGImage.copy()!), person: Person(id: 0, name: "The Other Man")),
            
        ]
        
        detailPagedVC.populate(identificationResults: identificationResults)
        peopleCollectionVC.populate(identifications: identificationResults)
        
        canvas.isLandscape = UIDevice.current.orientation.isLandscape
        canvas.identifications = identificationResults
        
        
        self.albumButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        
        
        self.cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
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
    override func viewDidAppear(_ animated: Bool) {
        
        // initial drawing
        self.adjustLayout()
        
        // gw: wait for above adjustment to finish photoView's frame
        // TODO: can this be unwrapped?
        DispatchQueue.main.async {
            let image = UIImage(imageLiteralResourceName: "team")
            self.zoomableImageVC.zoomableImageView.setImage(image: image)
            
            //self.updateAnnotation()
        }
        
    }
    
    // MARK: - trait collections
    // TODO: needs more understanding and research on which appriopriate lifecycle to use
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.adjustLayout()
        //self.updateAnnotation()
        
        // need to wait for adjust layout settle
        DispatchQueue.main.async {
            self.zoomableImageVC.zoomableImageView.fitImage()
        }
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
            DispatchQueue.main.async {
                self.zoomableImageVC.zoomableImageView.setImage(image: image)
                
            }

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
