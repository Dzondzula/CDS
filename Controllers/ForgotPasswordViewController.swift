//
//  ForgotPasswordViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//

import UIKit
import Firebase
class ForgotPasswordViewController: UIViewController, Storyboarded {

    @IBOutlet weak var emailText: UITextField!

    @IBAction func sendButton(_ sender: Any) {

       // navigationController?.pushViewController(MemebersViewController(), animated: true)
        //        let auth = Auth.auth()
//
//                auth.sendPasswordReset(withEmail: emailText.text!) { (error) in
//                    if  error == nil{
//                        print("error")
//                        return
//                    }
//
//                    print("sent")
//                }
    }
}
