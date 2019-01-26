//
//  Matching.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/26/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation
import FaceCropper

// a face identification result between a Face (from photo) and a Person (from your backend server known people set)
public class Identification {
    
    let face: Face
    let person: Person
    
    public init(face: Face, person: Person) {
        self.face = face
        self.person = person
    }
    
}
