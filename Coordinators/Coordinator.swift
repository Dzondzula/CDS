//
//  Coordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.6.22..
//

import UIKit
//AnyObject-That is because the compiler won't let us mark it as weak in the view if it isn't known to be a reference type and that is exactly what AnyObject does.Therefore, if the object conforming to the protocol needs to be stored in a weak property then the protocol must be a class-only protocol.
protocol Coordinator: AnyObject {
    var parentCoordinator : Coordinator? {get set}
    var finishDelegate : CoordinatorFinishDelegate? {get set}
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType {get}
    var navController : UINavigationController { get set }
    
    func start()
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case login, user, member, training, tab, app
}
