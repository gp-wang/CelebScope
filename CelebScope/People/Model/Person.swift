//
//  Person.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/26/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//
import Foundation

class Person {
    let id: Int
    let name: String
    
    let avartar: URL?
    let birthDate: Date?
    let birthPlace: String?
    let imdbId: String?
    let bio: String?
    
    
    // MARK: - constructors
    
    init(id: Int, name: String, avartar: URL? = nil, birthDate: Date? = nil,
         birthPlace: String? = nil, imdbId: String? = nil,  bio: String? = nil) {
        self.id = id
        self.name = name
        self.avartar = avartar
        self.birthDate = birthDate
        self.birthPlace = birthPlace
        self.imdbId = imdbId
        self.bio = bio
    }
}
