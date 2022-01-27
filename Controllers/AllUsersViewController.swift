//
//  AllUsersViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//
import FirebaseDatabase
import Firebase
import UIKit

class AllUsersViewController: UIViewController {
   
    var users : [UserInfo] = []
    var user: User!
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        
        table.register(MemberTableViewCell.self, forCellReuseIdentifier: "userCell")
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
        
        self.tabBarController!.navigationItem.rightBarButtonItems = [signOutButton]
        self.navigationController?.hidesBarsOnSwipe = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(tableView)//Put in extension
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
               fetch()//performBG
//        self.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
      
        
    }
    
    func fetch(){
//      let completed =
        DataObjects.infoRef.observe(.value){ snapshot,error in
            var newArray: [UserInfo] = []
            
            for child in snapshot.children{
                let snapshot = child as! DataSnapshot
                  
                if  let dictionary = snapshot.value as? [String:Any]{
                    let username = dictionary["username"] as! String
                    let firstName = dictionary["firstName"] as! String
                    let lastName = dictionary["lastName"] as! String
                    let profilePic = dictionary["pictureURL"] as? String
                    let training = dictionary["Training"] as? [String]
                    let isPaid = dictionary["isPaid"] as? Bool
                    let uid = dictionary ["uid"] as! String
                    let admin = dictionary["isAdmin"] as! Bool
                    
                    let userInformation = UserInfo(firstName: firstName, lastName: lastName, username: username,pictureURL: profilePic,training: training, uid: uid, admin: admin)
                    newArray.append(userInformation)
                    
                    
                    DispatchQueue.main.async {
                        self.users = newArray
                        print(self.users)
                        self.tableView.reloadData()
                    }
                }
    }
            }
        }
        //refObserver.append(completed) Not using because im deleting all informations when user sign out
    enum NetworkError: Error{
       case noDataAvailable
       case canNotProcessData
    }
    @objc func signOutTapped(){
        
//        guard let user = Auth.auth().currentUser else {return}
//        let onlineRef = DataObjects.rootRef.child("online/\(user.uid)")
//
//        onlineRef.removeValue { error,_ in
//            print("removing failed")
//            return
//        }
        
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
            resetDefaults()
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

extension AllUsersViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count - 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! MemberTableViewCell
        cell.config(with: users[indexPath.item])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemberViewController()
        vc.detailItem = users[indexPath.row]
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated: true)

    }
    
}

extension AllUsersViewController{
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
