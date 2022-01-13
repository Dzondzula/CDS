//
//  ViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Firebase
import UIKit

class LogInViewController: UIViewController {

    var handle : AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
                self.password.text = nil
                self.username.text = nil
                
            } else {
                print("you dont have that user")
            }
// Auth.auth().signIn(withEmail: email, password: password){result,_ in
//            let uid = Auth.auth().currentUser?.uid
//            let ref = DataObjects.infoRef.child(uid!)
//            ref.setValue(["uid":uid,"email":email,"password":password,"firstName":firstName,"lastName":lastName,"username":username])
//            self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
        }
    }
    
}


