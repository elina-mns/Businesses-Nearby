//
//  BusinessModel.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import Foundation

struct BusinessResponseModel: Codable {
    let businesses: [Businesses]
}

struct Businesses: Codable {
    let rating: String
    let price: String
    let phone: String
    let isClosed: String
    let categories: [Categories]
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case rating
        case price
        case phone
        case isClosed = "is_Closed"
        case name
        case imageURL = "image_url"
    }
}

struct Categories: Codable {
    let alias: String
    let title: String
}
