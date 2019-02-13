//
//  Person.swift
//  CelebScope
//
//  Created by Gaofei Wang on 1/26/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//
import Foundation
import UIKit

public class Person {
    let id: Int
    let name: String
    
    let avartar: UIImage?
//    let birthDate: Date?
//    let deathDate: Date?
    
    let birthDate: String?
    let deathDate: String?
    let birthPlace: String?
    let imdbId: String?
    let bio: String?
    let profession: String?
    
    // MARK: - constructors
    
//    public init(id: Int, name: String, avartar: UIImage? = nil, birthDate: Date? = nil, deathDate: Date? = nil,
    //                birthPlace: String? = nil, imdbId: String? = nil,  bio: String? = nil, profession: String? = nil) {
    public init(id: Int, name: String, avartar: UIImage? = nil, birthDate: String? = nil, deathDate: String? = nil,
                birthPlace: String? = nil, imdbId: String? = nil,  bio: String? = nil, profession: String? = nil) {
        self.id = id
        self.name = name
        self.avartar = avartar
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.birthPlace = birthPlace
        self.imdbId = imdbId
        self.bio = bio
        self.profession = profession
    }
}
