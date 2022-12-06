//
//  TrainingCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class TrainingCoordinator: NSObject,Coordinator {
    var type: CoordinatorType {.training}
    
    var finishDelegate: CoordinatorFinishDelegate?
    
   weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navController: UINavigationController
    
    
    init(navigationController: UINavigationController){
        self.navController = navigationController
    }

    func start(){
        let trainingVC = TrainingViewController()
        navController.setViewControllers([trainingVC], animated: true)
    }
}
