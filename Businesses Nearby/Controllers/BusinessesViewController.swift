//
//  GroceriesViewController.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var businesses: [BusinessResponseModel] = []
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            fatalError()
        }
        return cell
    }
    
    
}

//MARK: - Extension for UIImageView to process the link in JSON

extension UIImageView {
    
    func downloaded(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                completion?(nil)
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(image)
            }
        }.resume()
    }
}
