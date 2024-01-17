//
//  AllUsersController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

class AdminMembersCoordinator: NSObject, AdminBaseCoordinator {
    var parentCoordinator: Coordinator?
    

     var rootViewController: UIViewController

    var parentCoordinatorr: MainBaseCoordinator?

    var type: CoordinatorType {.member}

   weak var finishDelegate: CoordinatorFinishDelegate?

    var navController: UINavigationController?
    var childCoordinators: [Coordinator] = []

    private var dataManager: ClientManager
    init(navigationController: UINavigationController, dataManager: ClientManager) {
        self.rootViewController = navigationController
        self.dataManager = dataManager
    }

    func start() -> UIViewController {

        let allUsersVC = MemebersViewController(navController: rootViewController as! UINavigationController)
        allUsersVC.dataManager = dataManager
        allUsersVC.viewModel = MemberTableViewModel()
        allUsersVC.coordinator = self
        allUsersVC.title = "Members"
        allUsersVC.tabBarItem.title = "SSSSSSSS"

        allUsersVC.didSendSingOutEvent = { [weak self] in
            guard let self = self else {return}
            self.parentCoordinator?.finish()
        }
        rootViewController = UINavigationController(rootViewController: allUsersVC)
        rootViewController.tabBarItem.title = "SSS"

        return rootViewController
       // return allUsersVC
        // navController.setViewControllers([allUsersVC], animated: true)
    }

     func navigateTo(navigate to: AdminNav, _ member: UserInfo?) {
        switch to {
        case .signOut:
            signOutTapped()
        case .toMember:
            if let member = member {
                self.showMember(member)
            }
        }
    }

    func showMember(_ member: UserInfo) {
        var memberVC = MemberInfoViewController()

        memberVC.dataManager = dataManager
        memberVC.coordinator = self
        memberVC.detailItem = member

        (rootViewController as! UINavigationController).present(memberVC, animated: true)
    }
  func signOutTapped() {
      self.finish()

//           let rootViewController = UINavigationController()
//        let window =  (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
//           window?.rootViewController = rootViewController
//
//      let loginViewCoordinator =     LoginCoordinator(navigationController: rootViewController,
//    router: Router(rootController: rootViewController) )
//           loginViewCoordinator.start()

    }
//    func removeCoordinator(){
//        parentCoordinator?.childDidFinish(self)
//        parentCoordinator?.endTabCoordinator()
//    }

}
