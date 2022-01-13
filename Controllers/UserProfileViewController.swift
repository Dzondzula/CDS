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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
     
        containerView.topAnchor.constraint(equalTo: view.topAnchor),
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/3)
        
        ])
        
        fetch{ result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let userInfo):
                self.informations = userInfo
            }
            self.nameLabel.text = self.informations[0].username
            
        }
        
                guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
                      let url = URL(string: urlString) else {return}
                URLSession.shared.dataTask(with: url) {data,_,err in
                    guard let data = data, err == nil else {return}
        
                    DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.profilePicture.image = image
                    }
                }.resume()
        
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
                    
                    let userInformation = UserInfo(firstName: firstName, lastName: lastName, username: username,pictureURL: profilePic)
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
        
        guard let user = Auth.auth().currentUser else {return}
        let onlineRef = DataObjects.rootRef.child("online/\(user.uid)")
        
        onlineRef.removeValue { error,_ in
            print("removing failed")
            return
        }
        
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
                UserDefaults.standard.set(urlString, forKey: "url")
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

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
extension UILabel{

    
    func enable(){
        let label = UILabel()
        label.isUserInteractionEnabled = true
    }
//    func tapped(recognizer: UIGestureRecognizer){
//        if recognizer.state == .ended{
//            let label = UILabel()
//            label.isUserInteractionEnabled = true
//            label.becomeFirstResponder()
//            print("ide lol")
//        }
//    }
}
