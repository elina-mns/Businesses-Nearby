//
//  InfoViewController.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var isItOpenLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ratingName: UILabel!
    @IBOutlet weak var reviewCountName: UILabel!
    @IBOutlet weak var makeReservation: UIButton!
    
    var isReservationAvailable = false
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        imageView.layer.cornerRadius = imageView.frame.width / 3
        imageView.layer.borderWidth = 2
        
        guard let business = business else { return }
        locationLabel.text = " 🏃‍♀️ \(business.location.city) \(business.location.country) \(business.location.address1) \(business.location.address2 ?? "") \(business.location.address3 ?? "")"
        phoneLabel.text = "📲 " + business.phone
        ratingLabel.text = "⭐️ " + String(business.rating)
        reviewCountLabel.text = " 🧑‍💻" + String(business.reviewCount)
        if !business.isClosed {
            isItOpenLabel.text = "🙂 Yes"
        } else {
            isItOpenLabel.text = "😒 Closed"
        }
        questionLabel.text = "Is it open?"
        ratingName.text = "Rating:"
        reviewCountName.text = "Review Count:"
        makeReservation.isHidden = !isReservationAvailable
        makeReservation.layer.cornerRadius = (makeReservation.frame.width / 10) - 6
        makeReservation.layer.borderWidth = 2
    }
    
    func setImage() {
        guard let business = business else { return }
        imageView.downloaded(from: business.imageURL) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Couldn't upload an image this time.", okAction: nil)
                    self.imageView.image = UIImage(named: "error")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func makeReservationIsTapped(_ sender: UIButton) {
        guard let business = business else { return }
        UIApplication.shared.open(business.url)
    }
    
    
}
