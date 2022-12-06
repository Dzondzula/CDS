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
    

    var navController: UINavigationController
    
    
    init(navigationController: UINavigationController){
        self.navController = navigationController
    }

    func start(){
        let userVC = UserProfileViewController()
        navController.setViewControllers([userVC], animated: true)
    }
}
