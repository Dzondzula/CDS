//
//  AllUsersViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//
import Firebase
import UIKit

class AllUsersViewController: UIViewController {
   
    var users : [UserInfo] = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        
        table.register(MemberTableViewCell.self, forCellReuseIdentifier: "userCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        
        fetch{ result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let userInfo):
                self.users = userInfo
            }
            
            
        }
    }
    
    func fetch(completion: @escaping (Result<[UserInfo],NetworkError>)-> Void){
        
            let uid = Auth.auth().currentUser?.uid
            
//      let completed =
        DataObjects.infoRef.child(uid!).observe(.value){ snapshot,error in
            var newArray: [UserInfo] = []
            
            for child in snapshot.children{
                let snapshot = child as! DataSnapshot
                  
                if  let dictionary = snapshot.value as? [String:Any]{
                    let username = dictionary["username"] as! String
                    let firstName = dictionary["firstName"] as! String
                    let lastName = dictionary["lastName"] as! String
                    let profilePic = dictionary["pictureURL"] as? String
                    
                    let userInformation = UserInfo(firstName: firstName, lastName: lastName, username: username,pictureURL: profilePic)
                    newArray.append(userInformation)
                    print(newArray)
                    completion(.success(newArray))
                    print(newArray)
                }
                completion(.failure(.canNotProcessData))
    }
           
            }
        }
        //refObserver.append(completed) Not using because im deleting all informations when user sign out
        

    enum NetworkError: Error{
       case noDataAvailable
       case canNotProcessData
    }
}

extension AllUsersViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! MemberTableViewCell
        //cell.config(with: users[indexPath.item])
        cell.nameLabel.text = "idegas"
        cell.trainingLabel.text = "lol treniram"
        cell.profileImageView.image = UIImage(named: "venom")
        return cell
    }
}

extension AllUsersViewController{
    func setUpElements(){
        navigationItem.title = "All members"
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
}
