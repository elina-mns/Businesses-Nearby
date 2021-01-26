//
//  BusinessAPI.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import Foundation

class BusinessAPI {
    
    static let apiKey = "anNGTLhlmtoLfR5moDqC6Esv8EAHW4WvBFyFPjMB1qNAk9aixJjYYNNbs2nN8QN5K6SPXVcD5vmQeaiQxqeuJwfBCXCvCvlA6tDlqjD2BkPTkYujI1bg4uDg8X4QYHYx"
    
    enum EndPoints {
        case businessInfo
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .businessInfo:
                return "https://api.yelp.com/v3/businesses/search\(BusinessAPI.apiKey)"
            }
        }
    }
    
    class func requestBusinessInfo(location: UserLocation, completionHandler: @escaping (BusinessResponseModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.businessInfo.url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let downloadedBusinessData = try! decoder.decode(BusinessResponseModel.self, from: data)
            completionHandler(downloadedBusinessData, nil)
        })
        task.resume()
    }
}
