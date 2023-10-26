//
//  Storyboarded.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 6.6.22..
//
import UIKit
import Foundation

protocol Storyboarded {

    static var storyboardName: String {get}
    static var storyboardBundle: Bundle {get}
    static var storyboardIdentifier: String {get}

    static func instantiate() -> Self// self refers to the type conforming to this Storybarded protocol

}

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
