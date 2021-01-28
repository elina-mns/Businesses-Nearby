//
//  AppTabBarController.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-27.
//

import UIKit

class AppTabBarController: UITabBarController {

    let items = [(title: "Restaurants", image: UIImage(named: "restaurant")),
                 (title: "Groceries", image: UIImage(named: "grocery"))]

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.items?.enumerated().forEach({ (index, item) in
            item.title = items[index].title
            item.image = items[index].image
            let appearance = UITabBarItem.appearance()
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14)]
            appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
            
    
        })
    }

}
