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
    var selectedBusiness: Business?
    var locationManager: CLLocationManager?
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        setBottomButtonsAndTitles()
        loadingVC.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Add nav controller, tab bar controller and use its' index to set title and specify the request
    
    func setBottomButtonsAndTitles() {
        if let navigationController = navigationController,
           let indexOfController = navigationController.tabBarController?.viewControllers?.firstIndex(of: navigationController) {
            switch indexOfController {
            case 0:
                category = Category(alias: "restaurants", title: "Restaurants")
                title = "Restaurants"
            case 1:
                category = Category(alias: "grocery", title: "Groceries")
                title = "Groceries"
            default:
                break
            }
        } else {
            showAlert(title: "Error", message: "Couldn't find a category", okAction: nil)
        }
    }
    
    //MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            fatalError("Couldn't configure the cell this time. Table View Cell should be registered.")
        }
        
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        //extracting image from URL using extension
        cell.imageOfBusiness.downloaded(from: businesses[indexPath.row].imageURL) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    cell.imageOfBusiness.image = image
                    cell.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Couldn't upload an image this time (maybe poor connection)", okAction: nil)
                    cell.imageOfBusiness.image = UIImage(named: "error")
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
        cell.name.text = businesses[indexPath.row].name
        cell.rating.text = String(businesses[indexPath.row].rating) + " ⭐️"
        let location = businesses[indexPath.row].location
        cell.location.text = "\(location.city) \(location.country) \(location.address1) \(location.address2 ?? "") \(location.address3 ?? "")"
        cell.phone.text = businesses[indexPath.row].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBusiness = businesses[indexPath.row]
        performSegue(withIdentifier: "showInfoViewController", sender: self)
    }
    
    //MARK: - Select the cell and show/hide button "Make Reservation"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InfoViewController {
            vc.business = selectedBusiness
            vc.isReservationAvailable = category.alias == "restaurants"
            selectedBusiness = nil
        } else {
            self.showAlert(title: "Error", message: "Couldn't upload further info this time (maybe poor connection)", okAction: nil)
        }
    }
    
    //MARK: - Location Manager and Request info
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestBusinessInfo()
    }
        
    func requestBusinessInfo() {
        let userLocation = UserLocation(latitude: locationManager?.location?.coordinate.latitude,
                                        longitude: locationManager?.location?.coordinate.longitude)
        
        BusinessAPI.requestBusinessInfo(location: userLocation, category: category) { (response, error) in
            if let error = error {
                self.showAlert(title: "Error", message: "Couldn't perform the request this time (maybe poor connection)", okAction: nil)
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

