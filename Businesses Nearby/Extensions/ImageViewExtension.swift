//
//  ImageViewExtension.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-27.
//

import UIKit

//MARK: - Extension for UIImageView to process the link in JSON and to cache an image based on URL

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func downloaded(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        // check cached image
        if let cachedImage = imageCache.object(forKey: url.path as NSString)  {
            self.image = cachedImage
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async() {
                    completion?(nil)
                }
                return
            }
            DispatchQueue.main.async() {
                self?.image = image
                completion?(image)
            }
        }).resume()
    }
}
