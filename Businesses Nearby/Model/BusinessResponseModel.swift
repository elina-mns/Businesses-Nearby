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
    let rating: Double
    let price: String
    let phone: String
    let isClosed: Bool
    let categories: [Category]
    let reviewCount: Int
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case rating
        case price
        case phone
        case categories
        case reviewCount = "review_count"
        case isClosed = "is_closed"
        case name
        case imageURL = "image_url"
    }
}

struct Category: Codable {
    let alias: String
    let title: String
}
