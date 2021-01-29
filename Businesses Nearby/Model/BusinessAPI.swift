//
//  BusinessAPI.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import Foundation

class BusinessAPI {
    
    private struct DefaultParisCoordinates {
        static let latitude = 48.8566
        static let longitude = 2.3522
    }
    
    static let apiKey = "anNGTLhlmtoLfR5moDqC6Esv8EAHW4WvBFyFPjMB1qNAk9aixJjYYNNbs2nN8QN5K6SPXVcD5vmQeaiQxqeuJwfBCXCvCvlA6tDlqjD2BkPTkYujI1bg4uDg8X4QYHYx"
    
    enum EndPoints {
        case businessInfo(location: UserLocation, category: Category)
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case let .businessInfo(location, category):
                return "https://api.yelp.com/v3/businesses/search?categories=\(category.alias)&latitude=\(location.latitude ?? DefaultParisCoordinates.latitude)&longitude=\(location.longitude ?? DefaultParisCoordinates.longitude)"
            }
        }
    }
    
    class func requestBusinessInfo(location: UserLocation, category: Category, completionHandler: @escaping (BusinessResponseModel?, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.businessInfo(location: location, category: category).url)
        //Here there should be an authorization header for our request
        request.setValue("Bearer \(BusinessAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let downloadedBusinessData = try decoder.decode(BusinessResponseModel.self, from: data)
                completionHandler(downloadedBusinessData, nil)
            } catch {
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
}
