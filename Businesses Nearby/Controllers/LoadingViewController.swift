//
//  LoadingView.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-28.
//

import UIKit

//MARK: - Loading View with blur background before first view appears

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        blurEffectView.frame = self.view.bounds
           view.insertSubview(blurEffectView, at: 0)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
    }
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .blue
        indicator.startAnimating()
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        return blurEffectView
    }()
    
}
