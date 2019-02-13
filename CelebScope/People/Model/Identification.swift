//
//  Matching.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/26/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//

import Foundation
import FaceCropper

// a face identification result between a Face (from photo) and a Person (from your backend server known people set)
public class Identification {
    
    let face: Face
    
    // TODO: make one identification has 1 face but multiple (person, confidence) tuple list
    let person: Person
    let confidence: Double?
    
    public init(face: Face, person: Person, confidence: Double? = nil) {
        self.face = face
        self.person = person
        self.confidence = confidence
    }
    
}
