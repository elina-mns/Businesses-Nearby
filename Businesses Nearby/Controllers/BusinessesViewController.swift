//
//  GroceriesViewController.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var businesses: [Business] = []
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        checkAndRequestInfo()
    }
    
    //MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            fatalError()
        }
        
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        cell.imageOfBusiness.downloaded(from: businesses[indexPath.row].imageURL) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    cell.imageOfBusiness.image = image
                    cell.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    cell.imageOfBusiness.image = UIImage(named: "error")
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
        cell.name.text = businesses[indexPath.row].name
        cell.rating.text = String(businesses[indexPath.row].rating)
        let location = businesses[indexPath.row].location
        cell.location.text = "\(location.city) \(location.country) \(location.address1) \(location.address2 ?? "") \(location.address3 ?? "")"
        cell.phone.text = businesses[indexPath.row].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfoViewController", sender: self)
    }
    
    //MARK: - Location Manager and request info
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAndRequestInfo()
    }
    
    private func checkAndRequestInfo() {
        if locationManager?.authorizationStatus == .authorizedWhenInUse,
           CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
           CLLocationManager.isRangingAvailable() {
            requestBusinessInfo()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
        
    func requestBusinessInfo() {
        let userLocation = UserLocation(latitude: locationManager?.location?.coordinate.latitude ?? 0,
                                        longitude: locationManager?.location?.coordinate.longitude ?? 0)
        BusinessAPI.requestBusinessInfo(location: userLocation) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let responseExpected = response {
                self.businesses = responseExpected.businesses
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
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
