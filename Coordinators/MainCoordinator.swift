//
//  MainCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 6.6.22..
//
import UIKit
import Foundation
import Firebase
import Combine


class MainCoordinator: NSObject, MainBaseCoordinator, UINavigationControllerDelegate {



    var parentCoordinator: Coordinator?

    var parentCoordinatorr: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()

    lazy var tabCoordinator: TabCoordinator = TabCoordinator(tabBarController: rootViewController as! UITabBarController, dataManager: dataManager!)
   lazy var loginCoordinator: LoginCoordinator = LoginCoordinator(navigationController: navController, router: Router(rootController: rootViewController as! UINavigationController))


    lazy var navController: UINavigationController! = UINavigationController()// The AppCoordinator class will be responsible for navigating the application, which implies that it needs access to a UINavigationController instance.
 lazy var tabBarController: UITabBarController = UITabBarController()

    var type: CoordinatorType {.app}

    weak var finishDelegate: CoordinatorFinishDelegate?

    var dataManager: ClientManager?

    var childCoordinators: [Coordinator] = []

    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    // Because we don't want to expose the UINavigationController instance to the rest of the project, we define a computed property, rootViewController, of type UIViewController. In the closure of the computed property, we return a reference to the UINavigationController instance.

    func start() async {
        if UserDefaults.standard.bool(forKey: "Logged") {
           await showTabVC()
        } else {
             showLoginVC()
        }
    }

    func showLoginVC() {
        print("Function: \(#function), line: \(#line)")
        rootViewController = navController

        loginCoordinator = LoginCoordinator(navigationController: rootViewController as! UINavigationController, router: Router(rootController: rootViewController as! UINavigationController))
        // navController.navigationBar.isHidden = true
        loginCoordinator.parentCoordinator = self
        loginCoordinator.finishDelegate = self
        childCoordinators.append(loginCoordinator)
        let loginVC = loginCoordinator.start()
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    //   return loginVC
    }

  func showTabVC() async {
        rootViewController = tabBarController

       guard let user = Auth.auth().currentUser else {fatalError()}
        dataManager = ClientManager(currentUserUid: user.uid)

         tabCoordinator = TabCoordinator(tabBarController: rootViewController as! UITabBarController, dataManager: dataManager!)
        tabCoordinator.finishDelegate = self
        childCoordinators.append(tabCoordinator)

      let tabVC = await tabCoordinator.start()
      window.rootViewController = tabVC
      window.makeKeyAndVisible()
       // return tabVC
    }
}
extension MainCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .tab:
            navController.viewControllers.removeAll()
            tabBarController.viewControllers?.removeAll()
            showLoginVC()
        case .login:
            navController.viewControllers.removeAll()
                Task{
                    await showTabVC()
                }
        default:
            break
        }
    }
}
extension Coordinator {
    func childDidFinish(_ child: NSObject?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {

                childCoordinators.remove(at: index)
                break
        }
    }

    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// First, we remove any segues from the main storyboard. Second, the main storyboard needs to assign a storyboard identifier to every view controller it contains. By assigning a storyboard identifier to a view controller, the storyboard is able to instantiate that view controller. Third, we move the instantiation of view controllers to the coordinator. View controllers should not be responsible for instantiating other view controllers. Fourth, the coordinator is in charge of navigating between view controllers. A view controller should not know how to show or hide view controllers, including itself.
