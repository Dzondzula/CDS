//
//  main.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 3.5.22..
//

import UIKit

let appDelegateClass: AnyClass =
NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
