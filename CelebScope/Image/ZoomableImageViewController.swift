//
//  ZoomableImageViewController.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit


// gw: dedicated VC for the photoView
class ZoomableImageViewController: UIViewController {

    let zoomableImageView  = ZoomableImageView()
    
    init() {
        super.init(nibName: nil
            , bundle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomableImageView)
        
        setupInternalLayoutConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setupInternalLayoutConstraints()  {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: zoomableImageView.topAnchor),
            view.bottomAnchor.constraint(equalTo: zoomableImageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: zoomableImageView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: zoomableImageView.trailingAnchor),
            ])
    }
}
