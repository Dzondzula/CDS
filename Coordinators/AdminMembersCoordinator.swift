//
//  AllUsersController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 9.6.22..
//

import UIKit

enum AdminNav{
    case signOut
    case toMember
}

class AdminMembersCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    
    
    var type: CoordinatorType {.member}
    
    var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: Coordinator?
    var navController: UINavigationController
    var childCoordinators:[Coordinator] = []
    
    
    private var dataManager : DataManager
    init(navigationController: UINavigationController,dataManager: DataManager){
        self.navController = navigationController
        self.dataManager = dataManager
    }

    func start(){
        
        let allUsersVC = AdminMemebersViewController()
        allUsersVC.dataManager = dataManager
        navController.delegate = self
        allUsersVC.coordinator = self
        allUsersVC.title = "Members"
        allUsersVC.didSendSingOutEvent = { [weak self] in
            guard let self = self else {return}
            self.parentCoordinator?.finish()
        }
      
        navController.setViewControllers([allUsersVC], animated: true)
        
        
    }
    
    private func navigateTo(_ navigate: AdminNav, member: UserInfo?){
        switch navigate {
        case .signOut:
            signOutTapped()
        case .toMember:
            if let member = member {
                self.showMember(member)
            }
        }
    }

    func showMember(_ member: UserInfo){
        let memberVC = MemberViewController()
        
        memberVC.dataManager = dataManager
        memberVC.coordinator = self
        memberVC.detailItem = member
        
        navController.present(memberVC, animated: true)
        
    }
  func signOutTapped(){
      self.finish()
//           let rootViewController = UINavigationController()
//        let window =  (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
//           window?.rootViewController = rootViewController
//
//      let loginViewCoordinator = LoginCoordinator(navigationController: rootViewController, router: Router(rootController: rootViewController) )
//           loginViewCoordinator.start()
           
    }
//    func removeCoordinator(){
//        parentCoordinator?.childDidFinish(self)
//        parentCoordinator?.endTabCoordinator()
//    }
    
}


