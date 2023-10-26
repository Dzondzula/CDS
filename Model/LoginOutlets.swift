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
        originalButtonText = self.titleLabel?.text// needed to bring back button text when hideLoading is being called
        self.setTitle("", for: UIControl.State.normal)

        if activityIndicator == nil {
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
@IBDesignable
class StyleTextField: UITextField {
    @IBInspectable
    var lineColor: UIColor = UIColor(red: 48 / 255, green: 173 / 255, blue: 99 / 255, alpha: 1) {
        didSet {
            bottomLine.backgroundColor = lineColor.cgColor
        }
    }
    private let bottomLine: CALayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // needs to be set here for Storyboard / IB
        self.borderStyle = .none
    }
    private func commonInit() {
        // removew border
        self.borderStyle = .none
        // bottom line color
        bottomLine.backgroundColor = lineColor.cgColor
        // add bottom line layer
        layer.addSublayer(bottomLine)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // update bottom line layer frame
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 2.0, width: bounds.width, height: 2.0)
    }
}
