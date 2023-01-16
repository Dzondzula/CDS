////
////  TabViewController.swift
////  MyFirebase
////
////  Created by Nikola Andrijasevic on 24.1.22..
////

import UIKit
//
//class TabViewController: UITabBarController {
//
//    weak var coordinator : MainCoordinator?
//    let adminMemberCoordinator = AdminMembersCoordinator(navigationController: UINavigationController())
//    let trainingCoordinator = TrainingCoordinator(navigationController: UINavigationController())
//    let userCoordinator = UserCoordinator(navigationController: UINavigationController())
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        adminMemberCoordinator.start()
//        trainingCoordinator.start()
//
//        let trainingVC = trainingCoordinator.navController
//        let uid = Auth.auth().currentUser?.uid
//        let child = getDataManager.userInfoRef.child(uid!)//add to service
//        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let data = snapshot.value as? Bool
//            if data == true{
//
//                let allVCC = self.adminMemberCoordinator.navController
//                self.viewControllers = [allVCC,trainingVC]
//
//
//                            } else{
//                                let userVCC = self.userCoordinator.navController
//                                self.viewControllers = [userVCC,trainingVC]
//                            }
//
//        })
//    }
//
////    var handle : AuthStateDidChangeListenerHandle?
////    weak var coordinator :MainCoordinator!
////    override func viewDidLoad() {
////    super.viewDidLoad()
////        self.navigationItem.setHidesBackButton(true, animated: false)
////        let userVC = UserProfileViewController()
////        let allVC = AllUsersViewController()
////        let trVC = TrainingViewController()
////        //self.view.addSubview(scrollView)
////        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "user")?.resize(28.0, 28.0), selectedImage: nil)
////        allVC.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "group")?.resize(28.0, 28.0), selectedImage: nil)
////        trVC.tabBarItem = UITabBarItem(title: "Training", image: UIImage(named: "event")?.resize(28.0, 28.0), selectedImage: nil)
//////        handle = Auth.auth().addStateDidChangeListener{error,user in
//////            if user != nil{
////        let uid = Auth.auth().currentUser?.uid
////        let child = getDataManager.userInfoRef.child(uid!)//add to service
////        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
////
////            let data = snapshot.value as? Bool
////            if data == true{
////
////                        self.setViewControllers([allVC,trVC], animated: false)
////
////                            } else{
////                                self.setViewControllers([userVC,trVC], animated: false)
////                            }
////
////        })
////            }
//    }
//
extension UIImage {
    func resize(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
        let widthRatio  = width / size.width
        let heightRatio = height / size.height
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
//
//
//
//                                                  
