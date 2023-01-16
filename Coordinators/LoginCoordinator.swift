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
    var dataManager : DataManager
    private let router: RouterProtocol
    weak var parentCoordinator : Coordinator?
    var navController: UINavigationController
    var childCoordinators:[Coordinator] = []
    
    init(navigationController: UINavigationController,router: RouterProtocol,dataManager: DataManager){
        self.navController = navigationController
        self.router = router
        self.dataManager = dataManager
    }
    
    func start(){
        let loginVC = LogInViewController.instantiate()
        navController.delegate = self
        loginVC.didSendEvent = {[weak self] in
            self?.finish()
        }
        loginVC.title = "S"
        navController.navigationBar.isHidden = true
        loginVC.coordinator = self
        self.router.setRootModule(loginVC)
        // navController.setViewControllers([loginVC], animated: true)
    }
    
    func showRegister(){
        let vc = RegisterViewController.instantiate()
        vc.dataManager = dataManager
        vc.coordinator = self
        navController.navigationBar.isHidden = false
        router.push(vc)
        //navController.pushViewController(vc, animated: true)
        
        
    }
    
    //    func toTabBar(){
    //        self.finish()
    ////       let rootViewController = UITabBarController()
    ////       let window =  (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    ////        window?.rootViewController = rootViewController
    ////
    ////        let tabCoordinator = TabCoordinator(tabBarController: rootViewController, navController: navController )
    ////        tabCoordinator.start()
    ////        childCoordinators.append(tabCoordinator)
    //    }
    
    func finished(){
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit{
        print("LoginCoordinator deinit")
    }
}
