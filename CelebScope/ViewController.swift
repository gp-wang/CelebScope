//
//  ViewController.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import GoogleMobileAds

import GoogleSignIn

class ViewController:  UIViewController {
    struct Constants {
        
        // the ratio of the content (e..g face) taken inside the entire view
        static let contentSpanRatio: CGFloat = 0.8
        static let ROUND_BUTTON_DIAMETER: CGFloat = 60
        static let RECT_BUTTON_WIDTH: CGFloat = 80
        static let RECT_BUTTON_HEIGHT: CGFloat = 35

        static let RECT_BUTTON_CORNER_RADIUS: CGFloat = 5
        static let HALF_CONTEXT_WORD_LIMIT: Int = 5 // half: forward and backward
        static let CONTEXT_SYMBOL_LIMIT = 30
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
    
    
    // gw: container of detailsContainerView and signStatusView, taking up 0.444 of the screen area
    // this is a view group
    let splitScreenView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = Colors.lightGrey
        return _view
    } ()
    
    // gw: this is the container view for details, it can be either the paged view (portrait), or the collection view (landscape)
    let detailsContainerView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = Colors.lightGrey
        return _view
    } ()
    
    
    // ----------------- view group [searchView] begins -----------------
    // this is a view group
    let searchView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = UIColor.clear
        return _view
    } ()
    let cameraButton = RoundButton(UIImage(imageLiteralResourceName: "camera"))
    let albumButton = RoundButton(UIImage(imageLiteralResourceName: "album"))
    let searchTextInput: UITextField = {
        
        let _input = UITextField(frame: CGRect())
        _input.translatesAutoresizingMaskIntoConstraints = false
        _input.placeholder = "..."
        _input.alpha = 0.6
        _input.backgroundColor = UIColor.white
        _input.textColor = UIColor.black
        _input.layer.cornerRadius = Constants.RECT_BUTTON_CORNER_RADIUS
        _input.textAlignment = .center
        
        
        return _input
    } ()
    
    let searchButton: UIButton = {
        let _button = UIButton()
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.yellow
        
        _button.setTitle(NSLocalizedString("findLabel", comment: ""), for: .normal)
        _button.setTitleColor(.darkGray, for: .normal)
        _button.alpha = 0.9
        // set corner radius: https://stackoverflow.com/a/34506379/8328365
        _button.layer.cornerRadius = Constants.RECT_BUTTON_CORNER_RADIUS
        
        return _button
    } ()
    
    // ----------------- view group [searchView] ends -----------------
    

    
    // backround view for sign in button
    // this is a view group
    let signInView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = UIColor.lightGray
        return _view
    } ()
    let signInButton: GIDSignInButton = {
        let _button = GIDSignInButton()
        _button.translatesAutoresizingMaskIntoConstraints = false
        
        return _button

    } ()
    
    
    
    
    // this is a view group
    let signStatusView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = UIColor.lightGray
        return _view
    } ()
    

    let signOutButton: UIButton = {
        let _button = UIButton()
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.red
        _button.alpha = 0.7
        _button.setTitle(NSLocalizedString("signOutLabel", comment: ""), for: .normal)

        _button.setTitleColor(.white, for: .normal)
        
        
        _button.layer.cornerRadius = Constants.RECT_BUTTON_CORNER_RADIUS
        _button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(14)

        return _button
    } ()
    
    let signInStatusText: UILabel = {
        let _label = UILabel()
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.backgroundColor = UIColor.lightGray
        _label.alpha = 0.6
        _label.textColor = UIColor.black
        
        // fit size dynamically
        //https://stackoverflow.com/questions/4865458/dynamically-changing-font-size-of-uilabel
        _label.numberOfLines = 2;
        // _label.minimumFontSize = 8;// deprecated
        _label.minimumScaleFactor = 0.4
        _label.adjustsFontSizeToFitWidth = true;
        _label.textAlignment = .center
        // _label.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
        return _label
    } ()
    
    
    let bottomViewGroup: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = UIColor.clear
        return _view
    } ()
    let menuButton = RoundButton(UIImage(imageLiteralResourceName: "menu"))
    let bannerView: GADBannerView = {
        let _bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        _bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        return _bannerView
    } ()
    
    
    
    var isSignedIn: Bool = false
    // TODO
//    @IBOutlet weak var disconnectButton: UIButton!
//    @IBOutlet weak var statusText: UILabel!
    
    var tooltipVC: TooltipViewController?
    
    
//    var identificationResults: [Identification]  {
//        didSet {
//            DispatchQueue.main.async {
//                // gw: updating logic for annotations etc
//                self.detailPagedVC.populate(identificationResults: self.identificationResults)
//                self.peopleCollectionVC.populate(identifications: self.identificationResults)
//
//                self.canvas.isLandscape = UIDevice.current.orientation.isLandscape
//                self.canvas.identifications = self.identificationResults
//            }
//
//        }
//    }
    
    var matchedStrings: [MatchedString]  {
        didSet {
            DispatchQueue.main.async {
                // gw: updating logic for annotations etc
                self.detailPagedVC.populate(matchedStrings: self.matchedStrings)
                self.peopleCollectionVC.populate(matchedStrings: self.matchedStrings)
                
                self.canvas.isLandscape = UIDevice.current.orientation.isLandscape
                self.canvas.matchedStrings = self.matchedStrings
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
    

    
 
    
    //var pageViewDelegate: PeoplePageViewDelegate?
    init() {
        self.matchedStrings = []
        
        super.init(nibName: nil
            , bundle: nil)
        
        // MARK: - further setup of field properties
        

        
        // ------------------------- make VC hierarchy ------------------------------------
        // stack views
        // gw: setting up view hierachy across multiple VC's, (should be OK per: )
        // https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/TheViewControllerHierarchy.html
        // also note we set the autolayout constraints in this main VC
        self.addChild(peopleCollectionVC)
        self.addChild(zoomableImageVC)
        self.addChild(detailPagedVC)
        
        
        // ---------------- make view hierachy ------------------------
        view.addSubview(zoomableImageVC.view)
        view.addSubview(canvas)
        
        detailsContainerView.addSubview(peopleCollectionVC.view)
        detailsContainerView.addSubview(detailPagedVC.view)
        splitScreenView.addSubview(detailsContainerView)

        signStatusView.addSubview(signInStatusText)
        signStatusView.addSubview(signOutButton)
        splitScreenView.addSubview(signStatusView)

        view.addSubview(splitScreenView)

        // searchView
        searchView.addSubview(cameraButton)
        searchView.addSubview(albumButton)
        searchView.addSubview(searchTextInput)
        searchView.addSubview(searchButton)
        view.addSubview(searchView)
        
        // google sign in
        signInView.addSubview(signInButton)
        view.addSubview(signInView)
        
        
        // ads
        bottomViewGroup.addSubview(menuButton)
        bottomViewGroup.addSubview(bannerView)
        view.addSubview(bottomViewGroup)
        
        
        //view.addSubview(detailPagedVC.view)
        
        
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
        
        
         searchTextInput.delegate = self
        
        // TODO:temp
        detailPagedVC.view.isHidden = true
        
        
        
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
        // view.bringSubviewToFront(detailPagedVC.view)
        view.bringSubviewToFront(zoomableImageVC.zoomableImageView)
        view.bringSubviewToFront(canvas)
        view.bringSubviewToFront(bannerView)
        view.bringSubviewToFront(signInView)
//        view.bringSubviewToFront(signOutButton)
//        view.bringSubviewToFront(signInStatusText)
        
//        if(isFirstTime) {
//            self.view.bringSubviewToFront(tooltipVC!.view)
////            self.view.bringSubviewToFront(self.cameraButton)
////            self.view.bringSubviewToFront(self.albumButton)
//        }
        
        
        
        // -- constraints
        
        self.setupLayoutConstraints()
        

        // buttons
        self.albumButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
         self.menuButton.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        self.searchButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        self.signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
       
        
        matchedStrings = []
        

        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // hide nav bar in root view VC: https://stackoverflow.com/a/2406167/8328365
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.adjustLayout(UIDevice.current.orientation.isLandscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    @objc func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        signInStatusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            // Signed in
            signInView.isHidden = true
            signOutButton.isHidden = false
            // disconnectButton.isHidden = false
        } else {
            signInView.isHidden = false
            signOutButton.isHidden = true
            // disconnectButton.isHidden = true
            signInStatusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.signInStatusText.text = userInfo["statusText"]!
            }
        }
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
    
    // note: currently this cache hashes by UIImage object, not its content
    // TODO: hash by content
    let cache = Cache()
    
    @objc func startSearch() {
        let image =  self.zoomableImageVC.zoomableImageView.imageView.image!
        let text = self.searchTextInput.text!
        if let cachedResponse =  cache.cachedResponses[image] {
            gw_log("reuse cached response")
            searchForTextInOcrResult(text,cachedResponse)
        } else {
            gw_log("fire new API request")
            searchTextInImage(text,image, completionHandler: searchForTextInOcrResult, accessToken: GIDSignIn.sharedInstance()!.currentUser!.authentication.accessToken, cache: cache)
        }
    }
    
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // gw: see AppDelegate.init()
        //GIDSignIn.sharedInstance().clientID = "399591616840-7ogh03vhapiqcaudu76vp0g1aili57k3.apps.googleusercontent.com"
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        signInStatusText.text = "Initialized app ..."
        toggleAuthUI()
        
        
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
        
        
        // gw: note you should use the 'size' (the size will transition to) to decide the orientation.
        //     (you should NOT use the UIDevice.current.orientation.isLandscape. )
        self.adjustLayout(size.width > size.height ? true : false)
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
            if (viewControllerIndex > self.matchedStrings.count) {
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
                zoomingActionTaker.zoom(to: singlePersonViewController.matchedString.boundingBox,  animated: true)
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
    
    
    private func adjustLayout(_ isLandScape: Bool) {
        guard let collectionViewFlowLayout =  self.peopleCollectionVC.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            NSLog("failed to convert layout as flow layout")
            
            return
            
        }
        
        canvas.isLandscape = UIDevice.current.orientation.isLandscape
        
        // TODO: for now hide canvas unless Landscape
        canvas.isHidden = !canvas.isLandscape
        
        if isLandScape {
        //if UIDevice.current.orientation.isLandscape {
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
    
    
    //func searchForTextInOcrResult(_ ocrRespData: Data?, _ ocrRespResponse: URLResponse?, _ ocrRespError: Error?, _ text: String, _ image: UIImage) {
    func searchForTextInOcrResult(_ text: String, _ googleApiResponse: GoogleCloudVisionApiResponses) {
        
                        
        
        
        
        // TODO
        // create text_matching_identification and populate into pageDetail view and collection view for display
        
        // gw: naive search algorithm:
        // search text: remove all whitespaces / breaks
        // then, in the detected text, match above search text symbol by symbol
        // this should work for both CN and EN
        
        
        var matchedStrings: [MatchedString] = []
        
        
        let rawSearchText = text
        
        var value = NSMutableString(string:rawSearchText)
        let pattern = "\\s"
        let regex = try? NSRegularExpression(pattern: pattern)
        regex?.replaceMatches(in: value, options: .reportProgress, range: NSRange(location: 0,length: value.length), withTemplate: "")
        // This will print We are big now lot of sales the money and cards Rober Langdon and Ambra Vidal.
        //print(value)
        
        // regex replacement
        
        let searchText: String = value as! String
        
        
        
        
        var symbolIndex: Int = 0
        for _response in googleApiResponse.responses {
            for _page in _response.fullTextAnnotation.pages {
                blockLoop: for _block in _page.blocks {
                    // gw: search within the max unit of block, so for each block we reinit the match pointer
                    // pointer of matched up to which char in the searchText
                    
                    var symbols: [Symbol] = []
                    // a list of bools which mark whether the index is a wordboundary
                    var wordBoundaries: [Bool] = []
                    //                                var contexts: [Word] = []
                    // compose a list for strStr search
                    var symbolToParagraphIndex: [Int] = []
                    for (pIndex, _paragraph) in _block.paragraphs.enumerated() {
                        for _word in _paragraph.words {
                            
                            for (sIndex, _symbol) in _word.symbols.enumerated() {
                                // mark first symbol as word boundary
                                wordBoundaries.append(sIndex  == 0)
                                symbols.append(_symbol)
                                symbolIndex += 1
                                
                            }
                        }
                    }
                    
                    // strStr search
                    // swift way to guarantee non-empty range
                    if symbols.count >= searchText.count {
                        var matchedSymbols : [Symbol] = []
                        outer: for i in 0..<(symbols.count - searchText.count) {
                            let _symbol = symbols[i]
                            
                            var j: Int = 0
                            var jIndex = searchText.index(searchText.startIndex, offsetBy: j)
                            var jChar: Character = searchText[jIndex]
                            
                            inner: while jChar.lowercased() == symbols[i+j].text.first?.lowercased() {
                                matchedSymbols.append(symbols[i+j])
                                j += 1
                                if j == searchText.count {
                                    // mark complete and ends current loop
                                    
                                    // make copy for constructing matched String
                                    var dupMatchedSymbols : [Symbol] = matchedSymbols
                                    matchedSymbols = []
                                    
                                    //let paragraphIndex: Int = symbolToParagraphIndex[i]
                                    
                                    // make context
                                    var k = i + j
                                    //var context: [String] = []  // a list of words
                                    //var currWord: [String] = []
                                    var context: [Character] = []
                                    var wordCnt: Int = 0
                                    // search backward
                                    while k > 0 && wordCnt < Constants.HALF_CONTEXT_WORD_LIMIT {
                                        context.insert(symbols[k].text.first!, at: 0)
                                        if wordBoundaries[k] {
                                            context.insert(" ", at: 0)
                                            wordCnt += 1
                                        }
                                        k -= 1
                                    }
                                    
                                    // search forward
                                    k = i + j + 1
                                    wordCnt = 0
                                    while k < symbols.count && wordCnt < Constants.HALF_CONTEXT_WORD_LIMIT {
                                        context.append(symbols[k].text.first!)
                                        if wordBoundaries[k] {
                                            context.insert(" ", at: 0)
                                            wordCnt += 1
                                        }
                                        k += 1
                                    }
                                    
                                    
                                    let match = MatchedString(searchText: searchText, symbols: dupMatchedSymbols, context: String(context))
                                    matchedStrings.append(match)
                                    
                                } else {
                                    
                                    
                                    jIndex = searchText.index(searchText.startIndex, offsetBy: j)
                                    jChar = searchText[jIndex]
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                }
            }
        }
        
        // TODO: construct the pageDetails and collectionView from match matchIdentifications
        self.matchedStrings = matchedStrings
        
        
        
        
    }
    
    
    
}

extension ViewController: UITextFieldDelegate {
    
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to begin")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.green
        print("Editing is began")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to end")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended")
        textField.backgroundColor = UIColor.white
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "$" {
            
            return false
        }
            
        else {
            
            return true
        }
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("Clear Button pressed")
        return true
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if self.searchTextInput.isFirstResponder {
//
//            self.searchTextInput.becomeFirstResponder()
//        }
//        else {
//
//            self.searchTextInput.resignFirstResponder()
//        }
        
        
        
        self.searchTextInput.resignFirstResponder()
        
        // alt way to dismiss keyboard
        //          https://stackoverflow.com/questions/29882775/resignfirstresponder-vs-endediting-for-keyboard-dismissal
        // self.searchTextInput.endEditing(true)
        return true
    }
    
    
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
        
        
        
        //gw: for identifying texts
        
        
        // gw: moved out as separate method
        //       searchTextInImage(text, image, completionHandler: processOCRResult, accessToken: GIDSignIn.sharedInstance()!.currentUser!.authentication.accessToken)
        /*
        
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
        } */
    }
}


// MARK: - image picker delegate
// gw: action after picking meage
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
            self.adjustLayout(UIDevice.current.orientation.isLandscape)
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
            
            
            
            // gw: text_search: comment this out and move to clicking "search" button
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
            
            //self.cleanUpForEmptyPhotoSelection()
            gw_log("picked 3")
        }
        
    }
    
}


