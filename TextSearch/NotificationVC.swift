//
//  ProgressVC.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/26/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

public enum NotificationType {
    case SIGNIN, PROGRESS, ERROR, NONE
}


public class NotificationVC: UIViewController {
    
    var notificationType: NotificationType = .NONE
    
    // screen 1
    
    // this is a view group, contains spinner and text
    let progressView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = .lightGray
        //_view.backgroundColor =  UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        return _view
    } ()
    
    let spinnerView: UIActivityIndicatorView = {
        let _spinnerView = UIActivityIndicatorView.init(style: .whiteLarge)
        
        
        _spinnerView.translatesAutoresizingMaskIntoConstraints = false
        _spinnerView.startAnimating()
        return _spinnerView
        
    } ()
    
    let progressText: UILabel = {
        let _label = UILabel()
        _label.text = NSLocalizedString("progressLabel", comment: "") // "progressLabel" = "Processing text in the provided image ... ";
        _label.textColor = .darkText
        _label.translatesAutoresizingMaskIntoConstraints = false
        
        _label.numberOfLines = 1;
        _label.minimumScaleFactor = 0.4
        _label.adjustsFontSizeToFitWidth = true;
        _label.textAlignment = .center
        //        _label.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
        return _label
    } ()
    
    
    
    // screen 2
    // this is a view group, contains error text
    let errorView: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = .lightGray
        //_view.backgroundColor =  UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        return _view
    } ()
    let errorText: UILabel = {
        let _label = UILabel()
        _label.text = NSLocalizedString("errorDefaultLabel", comment: "") // "errorDefaultLabel" = "Something went wrong...";
        
        _label.textColor = Colors.brightOrange
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.textAlignment = .center
        _label.numberOfLines = 2;
        
        _label.minimumScaleFactor = 0.4
        _label.adjustsFontSizeToFitWidth = true;
        //        _label.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
        return _label
    } ()
    
    let dismissButton:  UIButton = {
        let _button = UIButton()
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.white
        
        _button.setTitle(NSLocalizedString("dismissLabel", comment: ""), for: .normal)
        _button.setTitleColor(.darkGray, for: .normal)
        _button.alpha = 0.9
        // set corner radius: https://stackoverflow.com/a/34506379/8328365
        _button.layer.cornerRadius = ViewController.Constants.RECT_BUTTON_CORNER_RADIUS
        
        return _button
    } ()
    
    
    // screen 3
    // sign in indicator
    // screen 2
    // this is a view group, contains error text
//    let signInView: UIView = {
//        let _view = UIView()
//        _view.translatesAutoresizingMaskIntoConstraints = false
//        _view.backgroundColor = UIColor.lightGray
//        return _view
//    } ()
//    let signInPromote: UILabel = {
//        let _label = UILabel()
//        _label.text = "Please Sign in with Google Account to continue."
//
//        _label.textColor = Colors.brightOrange
//        _label.translatesAutoresizingMaskIntoConstraints = false
//        _label.textAlignment = .center
//        _label.numberOfLines = 2;
//
//        _label.minimumScaleFactor = 0.4
//        _label.adjustsFontSizeToFitWidth = true;
//        //        _label.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
//        return _label
//    } ()
//
//    let signInButton: GIDSignInButton = {
//        let _button = GIDSignInButton()
//        _button.translatesAutoresizingMaskIntoConstraints = false
//
//        return _button
//
//    } ()
    
    

    
    
    // MARK: - Constructors
    init() {
        
        // gw: has to use this constructor because super.init() does not exists, the param here is for dummy purpose
        super.init(nibName: nil
            , bundle: nil)
        
        progressView.addSubview(spinnerView)
        progressView.addSubview(progressText)
        view.addSubview(progressView)
        
        errorView.addSubview(errorText)
        errorView.addSubview(dismissButton)
        view.addSubview(errorView)
        
        
        // gw: don't set super view's background, let it be transparent, use it as a logical grouping container
        // modify each subview's background separately (finer control)
        //view.backgroundColor = .lightGray
        
        
        self.view.translatesAutoresizingMaskIntoConstraints = false         // gw: note to add this
        
        setupInternalLayoutConstraints()
        
        
        //----------
        self.dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        reset()
    }
    
    @objc func handleDismiss() {
        showNone()
    }
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showProgress() {
        notificationType = .PROGRESS
        updateViewStatus()
    }
    
    public func showError(_ msg: String) {
        notificationType = .ERROR
        errorText.text = msg
        updateViewStatus()
    }
    
    public func showNone() {
        notificationType = .NONE
        updateViewStatus()
    }
    
    public func reset() {
        showNone()
    }
    
    public func updateViewStatus() {
        
        DispatchQueue.main.async {
            // hide all
            self.errorView.isHidden = true
            self.progressView.isHidden = true
            
            switch self.notificationType {
            case .ERROR:
                self.errorView.isHidden = false
                break
            case .PROGRESS:
                self.progressView.isHidden = false
                break
            default:
                // NONE. keep all hidden
                break
            }
        }
    }
    
//    //gw: here, I control the view sequence using alpha instead of "bringToFront"
//    public func showProgress() {
//        // hide error view
//        errorView.isHidden = true
//
//        // activate progress view
//        //progressView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        progressView.isHidden = false
//
//    }
//
//    public func showError() {
//        // hide progress view
//        progressView.isHidden = true
//
//
//        // activate  error view
//        errorView.isHidden = false
//
//    }
//
//    public func hideAll() {
//
//        view.isHidden = true
//    }
    
    
    func setupInternalLayoutConstraints() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            
        ])
        
        setupProgressViewConstraint();
        setupErrorViewConstraint();
        
        
    }
    
    func setupProgressViewConstraint() {
        NSLayoutConstraint.activate([

            progressText.heightAnchor.constraint(equalTo: spinnerView.heightAnchor, multiplier: 1),
            progressText.topAnchor.constraint(equalTo: progressView.topAnchor),

            
            progressText.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            progressText.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            
            
            
            
            
            
            // -------------
            
            
           spinnerView.topAnchor.constraint(equalTo:  progressText.bottomAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),
            
            
            // spinner h:w = 1:1
            spinnerView.widthAnchor.constraint(equalTo: spinnerView.heightAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: ViewController.Constants.ROUND_BUTTON_DIAMETER),
            
            // spinner centerX = super
            spinnerView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            
        ])
    }
    
    func setupErrorViewConstraint() {
        NSLayoutConstraint.activate([
            

             errorText.heightAnchor.constraint(equalTo: dismissButton.heightAnchor, multiplier: 1),
             errorText.topAnchor.constraint(equalTo: errorView.topAnchor),

             
             errorText.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 10),
             errorText.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -10),
             
             
             
             
             
             
             // -------------
             
             
            dismissButton.topAnchor.constraint(equalTo:  errorText.bottomAnchor, constant: 10),
//             dismissButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
             dismissButton.widthAnchor.constraint(equalToConstant: ViewController.Constants.RECT_BUTTON_WIDTH),
              dismissButton.heightAnchor.constraint(equalToConstant: ViewController.Constants.RECT_BUTTON_HEIGHT),
             
             // spinner centerX = super
             dismissButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            
//
//            errorText.topAnchor.constraint(equalTo: errorView.topAnchor),
//            errorText.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
//            errorText.leadingAnchor.constraint(equalTo: errorView.leadingAnchor),
//            errorText.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            
            
            
            
            
        ])
        
    }
    
}
