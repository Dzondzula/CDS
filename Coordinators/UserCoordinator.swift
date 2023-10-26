//
//  UserCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class UserCoordinator: NSObject, Coordinator {
    var rootViewController: UIViewController

    var parentCoordinatorr: MainBaseCoordinator?

   weak var parentCoordinator: Coordinator?

    var type: CoordinatorType {.user}

    var finishDelegate: CoordinatorFinishDelegate?

   lazy var childCoordinators: [Coordinator] = []

    var dataManager: ClientManager
  //  var navController: UINavigationController!

    init(navigationController: UINavigationController, dataManager: ClientManager) {
        self.rootViewController = navigationController
        self.dataManager = dataManager
    }

    func start() -> UIViewController {
        let userVC = UserProfileViewController(dataManager: dataManager, tagContainer: TagContainer(handlers: [UserTagHandler()]))
        userVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: userVC)
        return rootViewController
///        navController.setViewControllers([userVC], animated: true)
        // return userVC
    }
}
