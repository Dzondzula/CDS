//
//  LoginCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class LoginCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    var type: CoordinatorType {.login}
    
   weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let router: RouterProtocol
    weak var parentCoordinator : Coordinator?
    var navController: UINavigationController
    var childCoordinators:[Coordinator] = []
    
    init(navigationController: UINavigationController,router: RouterProtocol){
        self.navController = navigationController
        self.router = router
    }

    func start(){
        let loginVC = LogInViewController.instantiate()
        navController.delegate = self
        loginVC.didSendEvent = {[weak self] in
            self?.finish()
        }
        loginVC.coordinator = self
        self.router.setRootModule(loginVC)
       // navController.setViewControllers([loginVC], animated: true)
    }
    
    func showRegister(){
        let vc = RegisterViewController.instantiate()
        vc.coordinator = self
        router.push(vc)
       //navController.pushViewController(vc, animated: true)
        
        
    }
    
    func toTabBar(){
        self.finish()
//       let rootViewController = UITabBarController()
//       let window =  (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
//        window?.rootViewController = rootViewController
//
//        let tabCoordinator = TabCoordinator(tabBarController: rootViewController, navController: navController )
//        tabCoordinator.start()
//        childCoordinators.append(tabCoordinator)
    }
    
    func finished(){
        parentCoordinator?.childDidFinish(self)
    }
}
