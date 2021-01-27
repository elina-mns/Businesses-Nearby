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
    
    let businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func makeReservationIsTapped(_ sender: UIButton) {
        
    }
}
