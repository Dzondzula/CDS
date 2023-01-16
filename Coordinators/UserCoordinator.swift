//
//  UserCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class UserCoordinator: NSObject,Coordinator {
   weak var parentCoordinator: Coordinator?
    
    var type: CoordinatorType {.user}
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    
   lazy var childCoordinators: [Coordinator] = []
    
    var dataManager : DataManager
    var navController: UINavigationController
    
    
    init(navigationController: UINavigationController,dataManager: DataManager){
        self.navController = navigationController
        self.dataManager = dataManager
    }

    func start(){
        let userVC = UserProfileViewController()
      
        navController.setViewControllers([userVC], animated: true)
    }
}
