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
    lazy var loadingVC: LoadingViewController = {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        return loadingVC
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(requestBusinessInfo), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        setBottomButtonsAndTitles()
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
        let business = businesses[indexPath.row]
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        //Extracting image from URL using extension "Image View Extension"
        cell.imageOfBusiness.downloaded(from: business.imageURL) { (image) in
            if image != nil {
                cell.imageOfBusiness.image = image
                cell.activityIndicator.stopAnimating()
            } else {
                cell.imageOfBusiness.image = UIImage(named: "error")
                cell.activityIndicator.stopAnimating()
            }
        }
        cell.name.text = business.name
        cell.rating.text = String(business.rating) + " ⭐️"
        let location = business.location
        cell.location.text = "\(location.city) \(location.country) \(location.address1) \(location.address2 ?? "") \(location.address3 ?? "")"
        cell.phone.text = business.phone
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
        }
    }
    
    //MARK: - Location Manager and Request info
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestBusinessInfo()
    }
        
    @objc
    func requestBusinessInfo() {
        let userLocation = UserLocation(latitude: locationManager?.location?.coordinate.latitude,
                                        longitude: locationManager?.location?.coordinate.longitude)
        /*   Presenting should go first and after it is done we perform an async request
         This way Loading View Controller knows about the request  */
        present(loadingVC, animated: true) {
            guard self.category != nil else { return }
            BusinessAPI.requestBusinessInfo(location: userLocation, category: self.category) { (response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.showAlert(title: "Error", message: "Couldn't perform the request this time (maybe poor connection)", okAction: nil)
                    } else if let responseExpected = response {
                        self.businesses = responseExpected.businesses
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    self.refreshControl.endRefreshing()
                    self.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

