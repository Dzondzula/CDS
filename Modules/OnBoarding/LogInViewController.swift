//
//  ViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Foundation
import Firebase
import UIKit

class LogInViewController: UIViewController, Storyboarded {

    var handle: AuthStateDidChangeListenerHandle?
    var didSendEvent: (() -> Void)!
    weak var coordinator: LoginCoordinator?
    var indicator = UIActivityIndicatorView()
    let broj = 2_567
    @IBOutlet weak var forgot: UIButton!
    @IBOutlet weak var register: LoginButton!
    @IBOutlet weak var login: LoginButton!
    @IBOutlet weak var username: StyleTextField!
    @IBOutlet weak var password: StyleTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.styleFilledButton(login)
        Utilities.styleHollowButton(register)
        //        Utilities.styleTextField(username)
        //        Utilities.styleTextField(password)
        // username.backgroundColor = .darkGray

        //        if UserDefaults.standard.bool(forKey: "Logged") == true {
        //             self.navigationController?.pushViewController(TabViewController(), animated: false)
        //        }
        //         else if  UserDefaults.standard.bool(forKey: "UserLogged") == true {
        //
        //                self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
        //
        //         else {
        //            return
        //        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard let handle = handle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(handle)
        // coordinator?.finished()
    }

    @IBAction private func registerTapped(_ sender: Any) {

        coordinator?.showRegister()
    }

    @IBAction private func loginTapped(_ sender: UIButton) {

        guard let username = username.text,
              let password = password.text,
              !username.isEmpty,
              !password.isEmpty
        else {return}
        login.showLoading()

        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if let error = error, user == nil {
                let ac = UIAlertController(title: "Sign in failed", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default) {  [weak self] _ in
                    self?.login.hideLoading()
                })
                self.present(ac, animated: true)
                return
            } else if user != nil {
                UserDefaults.standard.set(true, forKey: "Logged")

                self.login.hideLoading()
                self.didSendEvent()
                self.password.text = nil
            } else {
                print("you dont have that user")
                self.login.hideLoading()
            }
        }
    }

    deinit {
        print("loginVC deinit")
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
