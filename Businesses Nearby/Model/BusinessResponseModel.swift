//
//  BusinessModel.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import Foundation

struct BusinessResponseModel: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let rating: String
    let price: String
    let phone: String
    let isClosed: String
    let categories: [Category]
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case rating
        case price
        case phone
        case categories
        case isClosed = "is_Closed"
        case name
        case imageURL = "image_url"
    }
}

struct Category: Codable {
    let alias: String
    let title: String
}
