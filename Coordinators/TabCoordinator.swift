//
//  TabCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//
import Firebase
import UIKit
enum TabBarPage{
    case member
    case user
    case training

    
    
    init?(index: Int,isAdmin: Bool) {
        switch index {
        case 0:
            self = isAdmin ? .member  : .user
        case 1:
            self = .training
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .member:
            return  "Members"
        case .user:
            return "User"
        case .training:
            return "Training"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .user,.member:
            return 0
        case .training:
            return 1
        
        }
    }

    func pageIcon() -> UIImage {
        switch self {
        case .member:
            return  (UIImage(named: "group")?.resize(28.0, 28.0))!
        case .user:
            return (UIImage(named: "user")?.resize(28.0, 28.0))!
        case .training:
            return (UIImage(named: "event")?.resize(28.0, 28.0))!
        }
    }

    
    // Add tab icon selected / deselected color
    
    // etc
}
class TabCoordinator: NSObject,Coordinator{
    var navController: UINavigationController
    
    var type: CoordinatorType {.tab}
    var tabViewControllers : [UIViewController] = []
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: Coordinator?
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    var dataManager : DataManager
     
    init(tabBarController: UITabBarController,navController: UINavigationController,dataManager : DataManager){
        self.tabBarController = tabBarController
        self.navController = navController
        self.dataManager = dataManager
        
        super.init()
    }
    
    func start(){
        

        let uid = Auth.auth().currentUser?.uid
        let child = dataManager.userInfoRef.child(uid!)//add to service
        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as? Bool
            if data == true{
               
                let pages: [TabBarPage] = [.member, .training]
                    .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
                
                // Initialization of ViewControllers or these pages
                let controllers: [UINavigationController] = pages.map({ self.getTabController($0) })
                
                self.prepareTabBarController(withTabControllers: controllers)
                
                
                            } else{
                                let pages: [TabBarPage] = [.user, .training]
                                    .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
                                
                               
                                let controllers: [UINavigationController] = pages.map({ self.getTabController($0) })//primeni na svaki
                                
                                self.prepareTabBarController(withTabControllers: controllers)
                            }
            
        })
    }
    
    
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        //tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
       // tabBarController.selectedIndex = TabBarPage.
        /// Styling
       // tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        //navigationController.viewControllers = [tabBarController]
    }
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController{
        let navController = UINavigationController()
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageIcon(),
                                                     tag: page.pageOrderNumber())

        switch page {
        case .user:
          
            let userCoordinator = UserCoordinator(navigationController: navController, dataManager: dataManager)
            childCoordinators.append(userCoordinator)
            userCoordinator.parentCoordinator = self
            userCoordinator.start()
            
            return userCoordinator.navController

        case .member:
           let memberCoordinator = AdminMembersCoordinator(navigationController: navController, dataManager: dataManager)
            childCoordinators.append(memberCoordinator)
            memberCoordinator.parentCoordinator = self
            memberCoordinator.start()
            
            return memberCoordinator.navController
            
        case .training:
            let trainingCoordinator = TrainingCoordinator(navigationController: navController, dataManager: dataManager)
            childCoordinators.append(trainingCoordinator)
            trainingCoordinator.parentCoordinator = self
            trainingCoordinator.start()
            
            return trainingCoordinator.navController
        }
        
        
    }
    
    
    
//    func endTabCoordinator(){
//        parentCoordinator?.childDidFinish(self)
//    }
    
    deinit{
        print("TABBAR COOrDINATOR finished")
        print(childCoordinators.count)
    }
}

extension TabCoordinator : switchTaber{
    func switchToTab(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    
}
