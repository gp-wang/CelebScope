//
//  DemoManager.swift
//  CelebScope
// in chargge of demoing some preset photos when user has not selected any photo yet
//
//  Created by Gaopeng Wang on 2/6/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//



import UIKit
import FaceCropper

class DemoManager: NSObject {
    
    private struct Constants {
        static let period = 2 //seconds
        static let contentSpanRatio: CGFloat = 0.8
    }
    
    private var isOn = true
    
    struct Demo {
        let photo: UIImage
        let identifications: [Identification]
    }
    
    
    
    private let demos: [Demo] = {
        guard let dummyCGImage = UIImage(imageLiteralResourceName: "kelly").cgImage else {
            return []
        }
        
        
        let photo0 = UIImage(imageLiteralResourceName: "demo0")
        let face0_0 = Face(boundingBox: CGRect(x: 782, y: 372, width: 190, height: 190), image: dummyCGImage)
        let person0_0 = Person(id: 0, name: "Movie Star Mary", avartar: UIImage(imageLiteralResourceName: "demo0_avartar_0"), birthDate: "1990", deathDate: "2018", birthPlace: "Neverland", imdbId: "nm0000111", bio: "A very famous female movie star", profession: "Actress, Writer, Producer")
        let face0_1 = Face(boundingBox: CGRect(x: 1000, y: 324, width: 200, height: 200), image: dummyCGImage)
        let person0_1 = Person(id: 0, name: "Movie Star Jack", avartar: UIImage(imageLiteralResourceName: "demo0_avartar_1"), birthDate: "1980", deathDate: nil, birthPlace: "Neverland", imdbId: "nm0000222", bio: "A very famous male movie star", profession: "Actress, Writer, Producer")
        
        
        let demo0 = Demo(photo: photo0, identifications: [
            Identification(face: face0_0, person: person0_0),
            Identification(face: face0_1, person: person0_1)
            ])
        
        
        let photo1 = UIImage(imageLiteralResourceName: "demo1")
        let face1_0 = Face(boundingBox: CGRect(x: 2688, y: 387, width: 387, height: 387), image: dummyCGImage)
        let person1_0 = Person(id: 0, name: "Movie Star Mike", avartar: UIImage(imageLiteralResourceName: "demo1_avartar_0"), birthDate: "1970", deathDate: "2016", birthPlace: "Neverland", imdbId: "nm0000333", bio: "A very famous male movie producer", profession: "Actress, Writer, Producer")
        let face1_1 = Face(boundingBox: CGRect(x: 3545, y: 447, width: 374, height: 374), image: dummyCGImage)
        let person1_1 = Person(id: 0, name: "Movie Star Jennifer", avartar: UIImage(imageLiteralResourceName: "demo1_avartar_1"), birthDate: "1980", deathDate: nil, birthPlace: "Neverland", imdbId: "nm0000444", bio: "A very famous male movie writer", profession: "Actress, Writer, Producer")
        
        
        let demo1 = Demo(photo: photo1, identifications: [
            Identification(face: face1_0, person: person1_0),
            Identification(face: face1_1, person: person1_1)
            ])
        
        return [demo0, demo1]
    } ()
    
    unowned let zoomingActionTaker: ZoomableImageViewController
    unowned let pagingActionTaker: PeoplePageViewController
    
    init(zoomingActionTaker: ZoomableImageViewController, pagingActionTaker: PeoplePageViewController) {
        
        self.zoomingActionTaker = zoomingActionTaker
        self.pagingActionTaker = pagingActionTaker
        
        
        super.init()
        print("gw: init demo mgr")
        // 1
        
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let demos = self?.demos, let count = self?.demos.count else {
                print("gw: error demos array")
                return
            }
            
            print("starting photo showing")
            
            // init
            // set photo here

            // populate paged VC
            var i: Int = 0
            
            
            // process cycle
            while true {
                if let isOn = self?.isOn {
                    if !isOn {
                        break
                    }
                } else {
                    // gw: this is needed when self is destructed and we want to stop the photoshowing task
                    break
                }
 
                print("showing some photo for 2 sec ...")
                
                //scroll one page here
                let demo = demos[i]
                DispatchQueue.main.async {
                    zoomingActionTaker.setImage(image: demo.photo)
                    pagingActionTaker.populate(identificationResults: demo.identifications)
                }
                
                
                
                for (idx, page) in pagingActionTaker.pages.enumerated() {
                    // pagingActionTaker.delegate
                    DispatchQueue.main.async {
                        //pagingActionTaker.pageControl.currentPage = idx
                        pagingActionTaker.scrollToPage(idx)

                    }
                    
                    // if current page is a single person view controller, zoom to that person's face
                    if let singlePersonViewController = pagingActionTaker.pages[idx] as? SinglePersonPageViewController {
                        
                        // print("didFinishAnimating: \(viewControllerIndex)")
                        // zoomingActionTaker.zoom(to: self.identificationResults[viewControllerIndex].face.rect, with: Constants.contentSpanRatio, animated: true)
                        DispatchQueue.main.async {
                         zoomingActionTaker.zoom(to: singlePersonViewController.identification.face.rect, animated: true)
                        }
                        
                    } else if let summaryPageViewController = pagingActionTaker.pages[idx] as? SummaryPageViewController {
                        // self.zoomableImageVC.zoomableImageView.zoom(to: self.zoomableImageVC.zoomableImageView.imageView.bounds, with: Constants.contentSpanRatio, animated: true)
                        
                        DispatchQueue.main.async {
                             zoomingActionTaker.zoom(to: zoomingActionTaker.zoomableImageView.imageView.bounds, animated: true)
                        }
                       
                    } else {
                        print("gw: err: unkown type of page controller in paged view ")
                    }
                    
                    sleep(2)
                    print("gw: scroll one face")
                    
                }
                

                
                sleep(2)
                print("gw: scroll one photo")

                i = (i + 1) % count
            }
            
            // tear down
            
            // clearn identifications here
            
            
            print("finished photo showing")
        }
        
       
    }
    
    
    
    
    deinit {
        print("deiniting demoMenager")
        self.isOn = false
    }
    
    
    func initDemos() {
        
        
    }
    
    
}
