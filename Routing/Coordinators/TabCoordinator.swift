//
//  TabCoordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//
import Combine
import Firebase
import UIKit

enum TabBarPage {
    case admin
    case user
    case training

    init(index: Int, isAdmin: Bool) {
        switch index {
            case 0:
                self = isAdmin ? .admin : .user
            case 1:
                self = .training
            default:
                self = .user
        }
    }

    func pageTitleValue() -> String {
        switch self {
            case .admin:
                return  "Members"
            case .user:
                return "User"
            case .training:
                return "Training"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
            case .user, .admin:
                return 0
            case .training:
                return 1
        }
    }

    func pageIcon() -> UIImage {
        switch self {
            case .admin:
                return  (UIImage(named: "group")?.resize(28.0, 28.0))!
            case .user:
                return (UIImage(named: "user")?.resize(28.0, 28.0))!
            case .training:
                return (UIImage(named: "event")?.resize(28.0, 28.0))!
        }
    }
}

@MainActor
class TabCoordinator: NSObject, TabBarBaseCoordinator {
    var parentCoordinator: Coordinator?

    weak var parentCoordinatorr: MainBaseCoordinator?
    var navController: UINavigationController = UINavigationController()

    var type: CoordinatorType {.tab}


    weak var finishDelegate: CoordinatorFinishDelegate?

    var rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    var dataManager: ClientManager
    var tabBarControler: UITabBarController?
    lazy var trainingCoordinator: TrainingCoordinator = TrainingCoordinator(navigationController: navController, dataManager: dataManager)
    lazy var userCoordinator: UserCoordinator = UserCoordinator(navigationController: navController, dataManager: dataManager)
    lazy  var adminMemberCoordinator: AdminMembersCoordinator = AdminMembersCoordinator(navigationController: navController, dataManager: dataManager)

    init(tabBarController: UITabBarController, dataManager: ClientManager) {
        self.rootViewController = tabBarController

        self.dataManager = dataManager
    }
    func getRootTabBar(pages: [TabBarPage]) -> UITabBarController{

        let controllers: [UINavigationController] = pages.sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() }).map({ self.getTabController($0) })

        self.rootViewController = self.prepareTabBarController(withTabControllers: controllers)
        return rootViewController as! UITabBarController
    }
    
     func start() async -> UIViewController {

            let user = await dataManager.currentUserInformations()

            if  user.admin == true {
                return getRootTabBar(pages: [.admin, .training])
            } else {
                return  getRootTabBar(pages: [.user, .training])
            }
    }



//    func fetchCurrentUser(user uid: String) -> UIViewController {
//
//        dataManager.fetchUser(uid: uid) { user, _ in
//            self.dataManager.currentUser = user
//        }
//        return self.start()
//    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) -> UIViewController {
        /// Set delegate for UITabBarController
        // tabBarController.delegate = self
        /// Assign page's controllers
        (rootViewController as? UITabBarController)?.setViewControllers(tabControllers, animated: true)
        return rootViewController
        /// Let set index
        // tabBarController.selectedIndex = TabBarPage.
        /// Styling
        // tabBarController.tabBar.isTranslucent = false

        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        // navigationController.viewControllers = [tabBarController]
    }
    func selectPage(_ page: TabBarPage) {
        (rootViewController as? UITabBarController)?.selectedIndex = page.pageOrderNumber()
    }

    private func addTabItem(for vc: UINavigationController, _ page: TabBarPage) {
        vc.tabBarItem = UITabBarItem(
            title: page.pageTitleValue(),
            image: page.pageIcon(),
            tag: page.pageOrderNumber())
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()

        switch page {
            case .user:
                userCoordinator = UserCoordinator(navigationController: navController, dataManager: dataManager)
                childCoordinators.append(adminMemberCoordinator)
                childCoordinators.append(userCoordinator)
                userCoordinator.parentCoordinator = self
                // navController.setViewControllers([userCoordinator.start()], animated: false)

                let userVC = userCoordinator.start() as! UINavigationController
                addTabItem(for: userVC, page)
                return userVC
            case .admin:
                adminMemberCoordinator = AdminMembersCoordinator(navigationController: navController, dataManager: dataManager)
                childCoordinators.append(adminMemberCoordinator)
                adminMemberCoordinator.parentCoordinator = self
                // navController.setViewControllers([userCoordinator.start()], animated: false)

                let adminVC = adminMemberCoordinator.start() as! UINavigationController
                addTabItem(for: adminVC, page)

                return adminVC
            case .training:
                let trainingCoordinator = TrainingCoordinator(navigationController: navController, dataManager: dataManager)
                childCoordinators.append(trainingCoordinator)
                trainingCoordinator.parentCoordinator = self


                // navController.setViewControllers([trainingCoordinator.start()], animated: false)
                let trainingVC = trainingCoordinator.start() as! UINavigationController
                addTabItem(for: trainingVC, page)

                return trainingVC
        }
        //        navController.tabBarItem = UITabBarItem(
        //            title: page.pageTitleValue(),
        //            image: page.pageIcon(),
        //            tag: page.pageOrderNumber())
        //
        //        return navController
    }

    //    func endTabCoordinator(){
    //        parentCoordinator?.childDidFinish(self)
    //    }

    deinit {
        print("TABBAR COOrDINATOR finished")
        print(childCoordinators.count)
    }
}

extension TabCoordinator {
    func switchToTab(_ page: TabBarPage) {
        (rootViewController as? UITabBarController)?.selectedIndex = page.pageOrderNumber()
    }
}
