//
//  RegisterViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Firebase
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
                    let ref = DataObjects.infoRef.child(uid!)
                    ref.setValue(["uid":uid!,"email":email,"password":password,"firstName":firstName,"lastName":lastName,"username":username,"isAdmin":admin])
                    UserDefaults.standard.set(true, forKey: "UserLogged")
                    self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
                }
            } else {
                print("error in user creation")
            }
        }
    }
    
   

}
