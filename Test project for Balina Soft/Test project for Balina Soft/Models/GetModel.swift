//
//  GetModel.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

struct GetModel: Decodable {
    var content: [Content]?
    var page: Int32?
    var pageSize: Int32?
    var totalElements: Int64?
    var totalPages: Int32?
}

struct Content: Decodable {
    var id: Int32?
    var name: String?
    var image: String?
}
