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
