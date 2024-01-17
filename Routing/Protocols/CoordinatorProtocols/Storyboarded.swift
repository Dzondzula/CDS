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
