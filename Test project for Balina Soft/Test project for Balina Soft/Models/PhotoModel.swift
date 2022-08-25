//
//  PhotoModel.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 25.08.22.
//

import UIKit


struct PhotoModel {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = "image\(arc4random()).jpeg"
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}

