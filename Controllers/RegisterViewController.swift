//
//  RegisterViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Firebase
import UIKit

class RegisterViewController: UIViewController,Storyboarded {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    weak var coordinator: LoginCoordinator?
            
    override func viewDidLoad() {
        super.viewDidLoad()
       // tabBarController?.hidesBottomBarWhenPushed = true
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let admin:Bool = false
        guard let password = passwordText.text,
              let username = usernameText.text,
              let email = emailText.text,
              let lastName = lastName.text,
              let firstName = firstName.text,
              !password.isEmpty,
              !username.isEmpty,
              !lastName.isEmpty,
              !firstName.isEmpty
                
        else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){user,error in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password){result,_ in
                    let uid = Auth.auth().currentUser?.uid
                    let ref = getDataManager.userInfoRef.child(uid!)
                    ref.setValue(["uid":uid!,"email":email,"password":password,"firstName":firstName,"lastName":lastName,"username":username,"isAdmin":admin])
                    UserDefaults.standard.set(true, forKey: "Logged")
//                    self.navigationController?.pushViewController(TabViewController(), animated: true)
                }//toAnyObject can be used here
            } else {
                print("error in user creation")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = coordinator?.navController{
            let isPopping = !nav.viewControllers.contains(self)
            if isPopping{
                print("Popped out")
                print(nav.viewControllers.count)
            } else{
                print("not popped")
            }
        }
        //self.dismiss(animated: false)
    }
    deinit{
        print("DEINITIALIZED REGISTER")
    }

}
