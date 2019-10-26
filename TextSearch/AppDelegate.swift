//
//  AppDelegate.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/19/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        
        // gw: hack to solve that viewDidload is called BEFORE didFinishLaunchingWithOptions
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "399591616840-7ogh03vhapiqcaudu76vp0g1aili57k3.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.scopes.append(contentsOf: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/cloud-vision"])
    }


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
       let rootViewController = UINavigationController(rootViewController: customCollectionViewController)
        window?.rootViewController = rootViewController
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4230599911798280~4105662515")
        
        
        // gw: google sign in
        // Initialize sign-in
        // gw: see init()
       //  GIDSignIn.sharedInstance().clientID = "399591616840-7ogh03vhapiqcaudu76vp0g1aili57k3.apps.googleusercontent.com"
        // gw: https://github.com/EddyVerbruggen/nativescript-plugin-firebase/issues/1370
        // GIDSignIn.sharedInstance().delegate = self // moved into init()
        //GIDSignIn.sharedInstance()?.presentingViewController = rootViewController
        // GIDSignIn.sharedInstance()?.scopes.append(contentsOf: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/cloud-vision"])
        return true
    }
    
    // gw: for google sign in
    
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    // [END openurl]
    
    // [START openurl_new]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    // [END openurl_new]
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        // gw: add scopes for cloud api, values:
        //     https://www.googleapis.com/auth/cloud-platform
        // https://www.googleapis.com/auth/cloud-vision
        
        //GIDSignIn.sharedInstance()?.scopes.append(contentsOf: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/cloud-vision"])
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
        // [END_EXCLUDE]
    }
    // [END signin_handler]
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    // gw: end google sign in code
    

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

