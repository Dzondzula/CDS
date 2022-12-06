//
//  TabCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//
import Firebase
import UIKit

class TabCoordinator: NSObject,Coordinator,UITabBarControllerDelegate {
    var navController: UINavigationController
    
    var type: CoordinatorType {.tab}
    
    
   weak var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: Coordinator?
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    var allUsersCoordinator : AdminMembersCoordinator
    var trainingCoordinator: TrainingCoordinator
    var userCoordinator: UserCoordinator
     
    init(tabBarController: UITabBarController,navController: UINavigationController){
        self.tabBarController = tabBarController
        self.navController = navController
        allUsersCoordinator = AdminMembersCoordinator(navigationController: UINavigationController())
        trainingCoordinator = TrainingCoordinator(navigationController: UINavigationController())
        userCoordinator = UserCoordinator(navigationController: UINavigationController())
        super.init()
    }
    
    func start(){
        
        
//        userCoordinator.start()
//        let userVC = userCoordinator.navController
//        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "user")?.resize(28.0, 28.0), selectedImage: nil)
//        childCoordinators.append(userCoordinator)
//
//
//
//
//        allUsersCoordinator.start()
//        let allVC = allUsersCoordinator.navController
//        allVC.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "group")?.resize(28.0, 28.0), selectedImage: nil)
//        childCoordinators.append(allUsersCoordinator)
//        allUsersCoordinator.parentCoordinator = self
//
//
//        trainingCoordinator.start()
//        let trVC = trainingCoordinator.navController
//        trVC.tabBarItem = UITabBarItem(title: "Training", image: UIImage(named: "event")?.resize(28.0, 28.0), selectedImage: nil)
//        childCoordinators.append(trainingCoordinator)
//        trainingCoordinator.parentCoordinator = self
       
        tabBarController.delegate = self
       
        tabBarController.tabBar.isTranslucent = true
//        handle = Auth.auth().addStateDidChangeListener{error,user in
//            if user != nil{
        let trainingVC = getTabController(trainingCoordinator)
        let uid = Auth.auth().currentUser?.uid
        let child = getDataManager.userInfoRef.child(uid!)//add to service
        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as? Bool
            if data == true{
                
                let allVCC = self.getTabController(self.allUsersCoordinator)
                self.tabBarController.setViewControllers([allVCC,trainingVC], animated: true)
                
                
                            } else{
                                let userVCC = self.getTabController(self.userCoordinator)
                                self.tabBarController.setViewControllers([userVCC,trainingVC], animated: true)
                            }
            
        })
    }
    
    func getTabController(_ coordinator: Coordinator) -> UINavigationController{
        
       let nav = coordinator.navController
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        
        switch coordinator.type{
            
        case .user:
           
            nav.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "user")?.resize(28.0, 28.0), selectedImage: nil)
            childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
        case .member:
            
            nav.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "group")?.resize(28.0, 28.0), selectedImage: nil)
        case .training:
            
            nav.tabBarItem = UITabBarItem(title: "Training", image: UIImage(named: "event")?.resize(28.0, 28.0), selectedImage: nil)
        
        default:
            break
        }
        coordinator.start()
         return nav
        }
    
    //func prepareTabBarController(withTabContro)
    
    func endTabCoordinator(){
        parentCoordinator?.childDidFinish(self)
    }
}

