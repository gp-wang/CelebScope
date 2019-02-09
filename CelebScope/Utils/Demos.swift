//
//  Demos.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 2/8/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit
import FaceCropper

struct Demo {
    let photo: UIImage
    let identifications: [Identification]
}

class Demos {
    public static let demos: [Demo] = {
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
        
        
        
        // -------------------------
//        let photo2 = UIImage(imageLiteralResourceName: "demo2")
//        let face2_0 = Face(boundingBox: CGRect(x: 995, y: 296, width: 200, height: 200), image: dummyCGImage)
//        let person2_0 = Person(id: 0, name: "Movie Star Mike", avartar: UIImage(imageLiteralResourceName: "demo2_avartar_0"), birthDate: "1970", deathDate: "2016", birthPlace: "Neverland", imdbId: "nm0000333", bio: "A very famous male movie producer", profession: "Actress, Writer, Producer")
//
//
//        let demo2 = Demo(photo: photo2, identifications: [
//            Identification(face: face2_0, person: person2_0),
//            ])
        
        return [demo0, demo1]
    } ()
    
}
