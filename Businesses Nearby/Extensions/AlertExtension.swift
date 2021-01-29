//
//  AlertExtension.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-28.
//

import UIKit

//MARK: - Extension to show a pop-up alert

extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
