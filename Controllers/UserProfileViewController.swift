//
//  UserProfileViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import FirebaseStorage
import Firebase
import UIKit

class UserProfileViewController: UIViewController,UINavigationControllerDelegate {
    let uid = Auth.auth().currentUser?.uid
    lazy var storage = Storage.storage().reference(withPath: "images/\(uid!)")
    var informations: [UserInfo] = []
    var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    var refObserver:[DatabaseHandle] = []
    
    var arr = ["Ada","Belgrade","San Franci","dzi","Alakadava dzidzada"]
    
//    lazy var trainingView: UIView = {
//        let cv = UIView()
//        cv.backgroundColor = .red
//        cv.addSubview(collectionView)
//        collectionView.frame = cv.bounds
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: cv.topAnchor,constant: 30),
//            collectionView.leadingAnchor.constraint(equalTo: cv.leadingAnchor,constant: 10)
//        ])
        
//        return cv
//    }()
    lazy var collectionView :UICollectionView = {
         let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        
        cv.collectionViewLayout = layout
         cv.delegate = self
        cv.dataSource = self
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "trainingCell")

        cv.backgroundColor = .blue
        cv.translatesAutoresizingMaskIntoConstraints = false
         return cv
       
    }()
    lazy var containerView: UIView = {
       let cv = UIView()
        cv.backgroundColor = .blue
        
        cv.addSubview(profilePicture)
        profilePicture.isUserInteractionEnabled = true
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(pictureTapped))
        profilePicture .addGestureRecognizer(pictureTap)
        
        NSLayoutConstraint.activate([
        profilePicture.centerXAnchor.constraint(equalTo: cv.centerXAnchor),
        profilePicture.centerYAnchor.constraint(equalTo: cv.centerYAnchor),
        profilePicture.widthAnchor.constraint(equalToConstant: 120),
        profilePicture.heightAnchor.constraint(equalToConstant: 120),
        ])
        cv.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: cv.centerXAnchor),
           
        ])
        
        profilePicture.layer.cornerRadius = 120/2
        nameLabel.text = "Dzone Mafija"
        
        return cv
    }()
    
    lazy var profilePicture: UIImageView = {
        let picture = UIImageView()
        picture.backgroundColor = .brown
        picture.image = UIImage(named: "venom")
        picture.contentMode = .scaleAspectFill
        picture.clipsToBounds = true
        picture.layer.borderWidth = 3
        picture.translatesAutoresizingMaskIntoConstraints = false
        

        return picture
        
    }()
    
    let nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        return name
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
        
        let editBttn = editButtonItem
        navigationItem.rightBarButtonItems = [editBttn,signOutButton]
        view.backgroundColor = .white
       
        
        view.addSubview(containerView)
        view.addSubview(collectionView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
     
        containerView.topAnchor.constraint(equalTo: view.topAnchor),
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/3),
        
        collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 10),
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/3)
        
        ])
        
        fetch{ result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let userInfo):
                self.informations = userInfo
            }
            self.nameLabel.text = self.informations[0].username
//            if let picture = item.pictureURL,
//               let url = URL(string: picture){
//            profileImageView.loadImage(url: url)
            if let picture = self.informations[0].pictureURL,
               let url = URL(string: picture){
            self.profilePicture.loadImage(url: url)
            }
        }
        //desava se da admin nema sign out opciju pa u user defaults ostaje njegov link ka slicigmm
//                guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
//                      let url = URL(string: urlString) else {return}
//                URLSession.shared.dataTask(with: url) {data,_,err in
//                    guard let data = data, err == nil else {return}
//
//                    DispatchQueue.main.async {
//                    let image = UIImage(data: data)
//                    self.profilePicture.image = image
//                    }
//                }.resume()
        
            }

    func fetch(completion: @escaping (Result<[UserInfo],NetworkError>)-> Void){
        
            let uid = Auth.auth().currentUser?.uid
            
//      let completed =
        DataObjects.infoRef.child(uid!).observe(.value){ snapshot,error in
            var newArray: [UserInfo] = []
                if let dictionary = snapshot.value as? [String:Any]{
                    let username = dictionary["username"] as! String
                    let firstName = dictionary["firstName"] as! String
                    let lastName = dictionary["lastName"] as! String
                    let profilePic = dictionary["pictureURL"] as? String
                    let admin = dictionary["isAdmin"] as! Bool
                    let userInformation = UserInfo(firstName: firstName, lastName: lastName, username: username,pictureURL: profilePic, admin: admin)
                    newArray.append(userInformation)
                    print(newArray)
                    completion(.success(newArray))
                    print(newArray)
                }
                completion(.failure(.canNotProcessData))
    }
        //refObserver.append(completed)
        }
    enum NetworkError: Error{
       case noDataAvailable
       case canNotProcessData
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
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
            informations.removeAll()
            resetDefaults()
        } catch  {
            print("Auth sign out failed")
        }
    }
    
    @objc  func pictureTapped(){
        presentFotoActions()
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing{
           
        }
    }

}

extension UserProfileViewController: UIImagePickerControllerDelegate{
    
    func presentFotoActions(){
        let ac = UIAlertController(title: "Profile picture", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        ac.addAction(UIAlertAction(title: "Choose photo", style: .default){ [weak self] _ in
            self?.openPhotos()
        })
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedPicture = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{return}
        
        guard let imageData = selectedPicture.pngData() else{return}
        
        storage.putData(imageData, metadata: nil, completion: {_,error in
            guard error == nil else {
                print("failed to upload")
                return
            }//DispachQueue
            self.storage.downloadURL(completion: {url, error in
                guard let url = url, error == nil else {return}
                print("Obican url:\(url)")
                let urlString = url.absoluteString//convert URL to String
                let uid = Auth.auth().currentUser?.uid
                let ref = DataObjects.infoRef.child(uid!)
                let post = ["pictureURL":urlString]
                ref.updateChildValues(post)
               
                print("Download URL: \(urlString)")
               UserDefaults.standard.set(urlString, forKey: "ProfilePicture")
            })
        })
        
        
        self.profilePicture.image = selectedPicture
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func openPhotos(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}


extension UserProfileViewController:   UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // dataArary is the managing array for your UICollectionView.
//            let item = arr[indexPath.row]
//            let itemSize = item.size(withAttributes: [
//                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
//            ]).width + 30
        
        return  CGSize(width: arr[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23)]).width + 40, height: 40)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trainingCell", for: indexPath) as! TagCollectionViewCell
        cell.sportLabel.text = arr[indexPath.row]
        
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
       
        
        return cell
    }

}

extension UserProfileViewController {
    @objc func deleteTapped(_ sender: UIButton) {
        guard let index : Int = (sender.layer.value(forKey: "index")) as? Int else {return}
        arr.remove(at: index)
        let ref = DataObjects.infoRef.child(uid!)
                        let post = ["Training":arr]
                        ref.updateChildValues(post)
        collectionView.reloadData()
    }
}
