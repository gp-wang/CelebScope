//
//  PersonCollectionViewCell.swift
//  CelebScope
//
//  Created by Gaopeng Wang on 1/23/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
