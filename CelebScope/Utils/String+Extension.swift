//
//  String+Extension.swift
//  TextSearch
//
//  Created by Gaopeng Wang on 10/25/19.
//  Copyright © 2019 Gaopeng Wang. All rights reserved.
//

import Foundation


// https://stackoverflow.com/a/47230632/8328365
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
