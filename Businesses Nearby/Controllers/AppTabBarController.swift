//
//  AppTabBarController.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-27.
//

import UIKit

class AppTabBarController: UITabBarController {

    let items = ["Restaurants", "Groceries"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.items?.enumerated().forEach({ (index, item) in
            item.title = items[index]
        })
    }

}
