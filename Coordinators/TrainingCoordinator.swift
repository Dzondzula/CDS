//
//  TrainingCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class TrainingCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?    


    // if the property is declared as a lazy var, then the object is only initialized once, when it is first accessed, and reassigning the property will simply update its value. Reassigning a property with a new value will update its value and keep the existing instance of the object in memory
     var rootViewController: UIViewController



    var parentCoordinatorr: MainBaseCoordinator?

    var type: CoordinatorType {.training}

    var finishDelegate: CoordinatorFinishDelegate?
    var dataManager: ClientManager
  

    var childCoordinators = [Coordinator]()

    var navController: UINavigationController?

    init(navigationController: UINavigationController, dataManager: ClientManager) {
        self.rootViewController = navigationController
        self.dataManager = dataManager
    }

    func start() -> UIViewController {

        let trainingVC = TrainingViewController()
        trainingVC.dataManager = dataManager
        trainingVC.coordinator = self

        rootViewController = UINavigationController(rootViewController: trainingVC)
        return rootViewController
       // return trainingVC
    }
}
