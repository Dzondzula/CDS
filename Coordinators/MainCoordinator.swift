//
//  MainCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 6.6.22..
//
import UIKit
import Foundation

class MainCoordinator: NSObject,Coordinator,UINavigationControllerDelegate{
    var parentCoordinator: Coordinator?
    
    var navController: UINavigationController = UINavigationController()//The AppCoordinator class will be responsible for navigating the application, which implies that it needs access to a UINavigationController instance.
    var tabBarController: UITabBarController = UITabBarController()
    
    var type: CoordinatorType {.app}
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    let dataManager = DataManager()
    var rootViewController: UIViewController?
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    //Because we don't want to expose the UINavigationController instance to the rest of the project, we define a computed property, rootViewController, of type UIViewController. In the closure of the computed property, we return a reference to the UINavigationController instance.
    init(window: UIWindow){
        self.window = window
        
    }
    
    func start(){
        if UserDefaults.standard.bool(forKey: "Logged") == true {
            showTabVC()
        } else{
            showLoginVC()
        }
        
    }
    
    func showLoginVC(){
        rootViewController = navController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        let loginViewCoordinator = LoginCoordinator(navigationController: rootViewController as! UINavigationController, router: Router(rootController: rootViewController as! UINavigationController), dataManager: dataManager)
        //navController.navigationBar.isHidden = true
        loginViewCoordinator.finishDelegate = self
        loginViewCoordinator.start()
        childCoordinators.append(loginViewCoordinator)
        print(childCoordinators)
    }
    
    func showTabVC(){
        rootViewController = tabBarController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        let tabCoordinator = TabCoordinator(tabBarController: rootViewController as! UITabBarController, navController: navController, dataManager: dataManager)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
        
    }
    
    
}
extension MainCoordinator: CoordinatorFinishDelegate{
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .tab:
            navController.viewControllers.removeAll()
            tabBarController.viewControllers?.removeAll()
            showLoginVC()
        case .login:
            navController.viewControllers.removeAll()
            
            showTabVC()
        default:
            break
        }
    }
    
    
}
extension Coordinator{
    func childDidFinish(_ child: NSObject?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func finish(){
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
   

}


//First, we remove any segues from the main storyboard. Second, the main storyboard needs to assign a storyboard identifier to every view controller it contains. By assigning a storyboard identifier to a view controller, the storyboard is able to instantiate that view controller. Third, we move the instantiation of view controllers to the coordinator. View controllers should not be responsible for instantiating other view controllers. Fourth, the coordinator is in charge of navigating between view controllers. A view controller should not know how to show or hide view controllers, including itself.