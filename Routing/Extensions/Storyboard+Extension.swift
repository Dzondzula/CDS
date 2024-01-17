//
//  Storyboard+Extension.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 17.1.24..
//
import Foundation
import UIKit

extension Storyboarded where Self: UIViewController {
    // We use the protocol extension to provide default implementations for the computed properties and the instantiate() method. If a UIViewController subclass provides its own implementation, then that implementation is used instead of the default implementation provided by the protocol extension.

    static var storyboardName: String {
        return "Main"
    }

    static var storyboardBundle: Bundle {
        return .main
    }
    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName, bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Unable to instantiate ViewController with identifier\(storyboardIdentifier)")
        }
        return viewController
    }
}
