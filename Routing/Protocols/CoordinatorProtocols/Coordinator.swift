//
//  Coordinator.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.6.22..
//

import UIKit
// AnyObject-That is because the compiler won't let us mark it as weak in the view if it isn't known to be a reference type and that is exactly what AnyObject does.Therefore, if the object conforming to the protocol needs to be stored in a weak property then the protocol must be a class-only protocol.
protocol Coordinator: FlowCoordinator {
    var parentCoordinator: Coordinator? {get set}
    var finishDelegate: CoordinatorFinishDelegate? {get set}
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType {get}
   // var navController: UINavigationController! { get set }
    var rootViewController: UIViewController {get set}
    // @discardableResult func restToRoot() -> Self
    // The @discardableResult and the Self is important because we want to be able to construct paths that are very readable to future developers using the API. This approach let us to write: coordinator.resetToRoot().goToCart().goToCheckout() for example.
    // func start()
   // func start() -> UIViewController
}

// extension Coordinator {
//    var navigationRootViewController: UINavigationController? {
//        get {
//            (navController as? UINavigationController)
//        }
//    }
//
//    func resetToRoot() -> Self {
//        navigationRootViewController?.popToRootViewController(animated: false)
//        return self
//    }
// }

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case login, user, member, training, tab, app
}

enum AdminNav {
    case signOut
    case toMember
}
//
protocol MainBaseCoordinator: Coordinator {
    var loginCoordinator: LoginCoordinator {get}
    var tabCoordinator: TabCoordinator {get}
}

protocol LoginBaseCoordinator: Coordinator {

    func finished()
}

protocol AdminBaseCoordinator: Coordinator {
    func showMember(_ member: UserInfo)
    func signOutTapped()
    func navigateTo(navigate to: AdminNav, _ member: UserInfo?)
}


protocol TrainingBaseCoordinator: Coordinator {
}

protocol AdminCoordinated {
    var coordinator: AdminMembersCoordinator {get}
}

protocol TrainingCoordinated {
    var coordinator: TrainingCoordinator {get}
}
protocol LoginCoordinated {
    var coordinator: LoginBaseCoordinator {get}
}// Those are very important pieces because they tell the ViewController implementing them what flow they belong to. So every time we add a new UIViewController to the app, we can assign one of those to guarantee that our flows are cohesive.

protocol TabBarBaseCoordinator: Coordinator {
    func switchToTab(_ page: TabBarPage)
    // func moveTo(flow: AppFlow)
}
protocol FlowCoordinator: AnyObject {
    var parentCoordinatorr: MainBaseCoordinator? {get set}
}// Curently using something similar with switchtabber
