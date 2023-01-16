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
    var dataManager : DataManager
   weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navController: UINavigationController
    
    
    init(navigationController: UINavigationController,dataManager: DataManager){
        self.navController = navigationController
        self.dataManager = dataManager
    }

    func start(){
        let trainingVC = TrainingViewController()
        trainingVC.dataManager = dataManager
        
        navController.setViewControllers([trainingVC], animated: true)
    }
}
