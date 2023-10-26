//
//  LoginCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit



class LoginCoordinator: NSObject, LoginBaseCoordinator, UINavigationControllerDelegate {

    var parentCoordinator: Coordinator?

    var rootViewController: UIViewController

    var parentCoordinatorr: MainBaseCoordinator?

    var type: CoordinatorType {.login}

    weak var finishDelegate: CoordinatorFinishDelegate?
    private let router: RouterProtocol

    // var navController: UINavigationController!
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController, router: RouterProtocol) {
        self.rootViewController = navigationController
        self.router = router
    }

    func start() -> UIViewController {
        print("Function: \(#function), line: \(#line)")
        let loginVC = LogInViewController.instantiate()
        loginVC.didSendEvent = {[weak self] in
            self?.finish()
        }
        loginVC.title = "S"
        loginVC.coordinator = self

        // rootViewController = UINavigationController(rootViewController: loginVC)
        (rootViewController as! UINavigationController).delegate = self
        self.router.setRootModule(loginVC)
        // navController.setViewControllers([loginVC], animated: true)
        return rootViewController
    }

    func showRegister() {
        let vc = RegisterViewController.instantiate()
        vc.coordinator = self
        (rootViewController as! UINavigationController).navigationBar.isHidden = false
        router.push(vc)
        // navController.pushViewController(vc, animated: true)

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

    func finished() {
        parentCoordinator?.childDidFinish(self)
    }

    deinit {
        print("LoginCoordinator deinit")
    }
}
