//
//  LoginButtons.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 20.4.22..
//

import Foundation
import UIKit

class Button: UIButton {
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text//needed to bring back button text when hideLoading is being called
        self.setTitle("", for: UIControl.State.normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: UIControl.State.normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        NSLayoutConstraint.activate([
                  activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                  activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
              ])
    }
    
}
