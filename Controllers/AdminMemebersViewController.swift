//
//  AllUsersViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//
import FirebaseDatabase
import Firebase
import UIKit

protocol MemberListDelegate: AnyObject {
    func fetchMembers(completion: @escaping ([UserInfo]) -> Void)
    
}

protocol switchTaber : AnyObject{
    func switchToTab(_ page : TabBarPage)
}
class AdminMemebersViewController: UIViewController {
   
    var dataManager : DataManager!
    var viewModel : MemberTableViewModel!
    var users : [UserInfo] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var user: User!
    var didSendSingOutEvent : (() -> Void)!
    
    weak var coordinator: AdminMembersCoordinator?
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        
        table.register(MemberTableViewCellSwiftUI.self, forCellReuseIdentifier: "userCell")
        return table
    }()
    
   
    deinit{
    print("DEINITIALIZED ALLUSERS")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetchMembers{ members in
            self.users = members
           
        }
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target:self, action: #selector(signOutTapped))
        self.navigationItem.rightBarButtonItem = signOutButton
    
        view.backgroundColor = .white
        
        view.addSubview(tableView)//Put in extension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
       
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.checkPaymentStatus()
        
    }
    
    //refObserver.append(completed) Not using because im deleting all informations when user sign out
    enum NetworkError: Error{
        case noDataAvailable
        case canNotProcessData
    }
    @objc private func signOutTapped(){
        
        //        guard let user = Auth.auth().currentUser else {return}
        //        let onlineRef = DataObjects.rootRef.child("online/\(user.uid)")
        //
        //        onlineRef.removeValue { error,_ in
        //            print("removing failed")
        //            return
        //        }
        
        do{
            try Auth.auth().signOut()
            resetDefaults()
            didSendSingOutEvent()
           // coordinator?.parentCoordinator?.finish()
            //self.navigationController?.popToRootViewController(animated: true)
            
        } catch  {
            print("Auth sign out failed")
        }
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension AdminMemebersViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count - 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! MemberTableViewCellSwiftUI
        viewModel = MemberTableViewModel(members: users)
        let model = viewModel.memberViewModel(for: indexPath.row)
        //cell.config(with: model)
      return  MemberTableViewCellSwiftUI(member: model)
       // return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated: false)

        coordinator?.showMember(users[indexPath.row])

        
    }
    
}

extension AdminMemebersViewController{
    func setUpElements(){
        navigationItem.title = "All members"
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
}

//typealias Dispatch = DispatchQueue

//extension Dispatch {
//
//    static func background(_ task: @escaping () -> ()) {
//        Dispatch.global(qos: .background).async {
//            task()
//        }
//    }
//
//    static func main(_ task: @escaping () -> ()) {
//        Dispatch.main.async {
//            task()
//        }
//    }
//}
//Usage :
//
//Dispatch.background {
//    // do stuff
//
//    Dispatch.main {
//        // update UI
//    }
//}
