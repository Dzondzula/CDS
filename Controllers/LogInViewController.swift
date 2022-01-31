//
//  ViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Foundation
import Firebase
import UIKit

@IBDesignable class LogInViewController: UIViewController {

    var handle : AuthStateDidChangeListenerHandle?
   
    @IBOutlet weak var forgot: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
  
      
        Utilities.styleFilledButton(login)
        Utilities.styleHollowButton(register)
        Utilities.styleTextField(username)
        Utilities.styleTextField(password)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if UserDefaults.standard.bool(forKey: "Logged") == true {
             self.navigationController?.pushViewController(TabViewController(), animated: false)
        }
//         else if  UserDefaults.standard.bool(forKey: "UserLogged") == true {
//
//                self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
//
         else {
            return
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let handle = handle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(handle)
    }

    @IBAction func registerTapped(_ sender: Any) {
        
        //performSegue(withIdentifier: "toRegister", sender: nil)
        
    }
    @IBAction func loginTapped(_ sender: Any) {
        
        guard let username = username.text,
              let password = password.text,
              !username.isEmpty,
              !password.isEmpty
        else {return}

        Auth.auth().signIn(withEmail: username, password: password){ user,error in
            if let error = error, user == nil{
                let ac = UIAlertController(title: "Sign in failed", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(ac, animated: true)
            }
        }

        handle = Auth.auth().addStateDidChangeListener{error,user in
            if user != nil{
//                let uid = Auth.auth().currentUser?.uid
//                let child = DataObjects.infoRef.child(uid!)
//                child.child("isAdmin").observeSingleEvent(of: .value, with: {(snapshot) in
//
//                    let data = snapshot.value as? Bool
//                    if data == true{
                        UserDefaults.standard.set(true, forKey: "Logged")
//                        self.navigationController?.pushViewController(AllUsersViewController(), animated: true)
//
//
//                    } else {
//                        UserDefaults.standard.set(true, forKey: "UserLogged")
//                        self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
//                    }
//                })
                self.navigationController?.pushViewController(TabViewController(), animated: true)
                self.password.text = nil
                
            } else {
                print("you dont have that user")
            }
    }
    }
    
    }
extension LogInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == username {
      password.becomeFirstResponder()
    }

    if textField == password {
      textField.resignFirstResponder()
    }
    return true
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

