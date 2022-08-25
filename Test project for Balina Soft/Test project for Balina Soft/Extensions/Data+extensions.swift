//
//  Data+extensions.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 25.08.22.
//

import UIKit

extension Data {
    
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
