//
//  UserProfileViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
// switch

import FirebaseStorage
import Firebase
import UIKit

class UserProfileViewController: UIViewController, UINavigationControllerDelegate {

    var informations: [UserInfo] = []
    var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    var dataManager: ClientManager
    var refObserver: [DatabaseHandle] = []
    weak var coordinator: UserCoordinator?
    var arr: [String] = []
    let tagContainer: TagContainer
    init(dataManager: ClientManager, tagContainer: TagContainer) {
        self.tagContainer = tagContainer
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // define typealias-es
    typealias TranslationTuple = (name: String, translated: String)
    typealias TranslationDictionary = [String: String]

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        cv.collectionViewLayout = layout
        cv.delegate = self
        cv.dataSource = self
        cv.register(UserTagCollectionViewCell.self, forCellWithReuseIdentifier: "trainingCell")

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
            profilePicture.heightAnchor.constraint(equalToConstant: 120)
        ])
        cv.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: cv.centerXAnchor)
        ])

        profilePicture.layer.cornerRadius = 120 / 2
        nameLabel.text = "Dzone Mafija"

        return cv
    }()

    lazy var profilePicture: UIImageView = {
        let picture = UIImageView()
        picture.backgroundColor = .clear
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

    lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(paymentViewTitle)
        view.addSubview(paymentStatusPicture)
        view.addSubview(paymentStatusLabel)
        view.addSubview(trainingPriceLabel)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            paymentViewTitle.topAnchor.constraint(equalTo: view.topAnchor),
            paymentViewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

            trainingPriceLabel.topAnchor.constraint(equalTo: paymentViewTitle.bottomAnchor, constant: 40),
            trainingPriceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),

            paymentStatusPicture.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paymentStatusPicture.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            paymentStatusPicture.widthAnchor.constraint(equalToConstant: 120),
            paymentStatusPicture.heightAnchor.constraint(equalToConstant: 120),

            paymentStatusLabel.topAnchor.constraint(equalTo: paymentStatusPicture.bottomAnchor, constant: 10),
            paymentStatusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
        return view
    }()

    lazy var paymentStatusPicture: UIImageView = {
        let picture = UIImageView()
        picture.image = UIImage(named: "unpaid")
        picture.contentMode = .scaleAspectFill
        picture.clipsToBounds = true
        picture.translatesAutoresizingMaskIntoConstraints = false

        return picture
    }()

    lazy var paymentStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nije placeno"
        return label
    }()
    lazy var trainingPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00,00"
        return label
    }()

    lazy var paymentViewTitle: UILabel = {
        let label = UILabel()
        label.text = "Training status"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white

        view.addSubview(containerView)
        view.addSubview(collectionView)
        view.addSubview(paymentView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3),

            collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4),

            paymentView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            paymentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            paymentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            paymentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3)
        ])

        fetch { result in
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case.success(let userInfo):
                    self.informations = userInfo
            }
            self.nameLabel.text = self.informations[0].username

            DispatchQueue.main.async {
                guard let training = self.informations[0].trainings else {return }
                self.arr = training
                self.collectionView.reloadData()
            }
            if let picture = self.informations[0].pictureURL,
               let url = URL(string: picture) {
                self.profilePicture.loadImage(url: url)
            }

            let child2 = self.dataManager.currentUserReference().child("Payments")
            child2.child("isPaid").observeSingleEvent(of: .value, with: { [self](snapshot) in

                let data = snapshot.value as? Bool
                if data == true {
                    self.paymentStatusPicture.image = UIImage(named: "paid")
                    paymentStatusLabel.text = "Active"
                } else {
                    self.paymentStatusPicture.image = UIImage(named: "unpaid")
                    paymentStatusLabel.text = "Expired"
                }
            })
            child2.child("Price").observeSingleEvent(of: .value, with: { [self](snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! Int
                    trainingPriceLabel.text = "\(data),00 RSD"
                }
            })
        }

        // desava se da admin nema sign out opciju pa u user defaults ostaje njegov link ka slici
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

    func fetch(completion: @escaping (Result<[UserInfo], NetworkError>) -> Void) {

        //      let completed =
        dataManager.currentUserReference().observe(.value) { snapshot, _ in

            var users: [UserInfo] = []


                guard let snapshot = snapshot as? DataSnapshot else {return}

                let user = UserInfo(snapshot: snapshot)
                users.append(user!)



                completion(.success(users))
                // print(newArray)

            completion(.failure(.canNotProcessData))
        }
        // refObserver.append(completed)
    }
    enum NetworkError: Error {
        case noDataAvailable
        case canNotProcessData
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))

        let editBttn = editButtonItem
        self.navigationItem.rightBarButtonItems = [editBttn, signOutButton]
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
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
    @objc func signOutTapped() {

        //        guard let user = Auth.auth().currentUser else {return}
        //        let onlineRef = DataObjects.rootRef.child("online/\(user.uid)")
        //
        //        onlineRef.removeValue { error,_ in
        //            print("removing failed")
        //            return
        //        }

        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            informations.removeAll()
            resetDefaults()
        } catch {
            print("Auth sign out failed")
        }
    }

    @objc  func pictureTapped() {
        presentFotoActions()
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
        }
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate {

    func presentFotoActions() {
        let ac = UIAlertController(title: "Profile picture", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        ac.addAction(UIAlertAction(title: "Choose photo", style: .default) { [weak self] _ in
            self?.openPhotos()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedPicture = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}

        guard let imageData = selectedPicture.pngData() else {return}

        dataManager.storageRef(to: "profileImages").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("failed to upload")
                return
            }// DispachQueue
            self.dataManager.storageRef(to: "profileImages").downloadURL(completion: {[weak self] url, error in
                guard let url = url, let self, error == nil else {return}
                print("Obican url:\(url)")
                let urlString = url.absoluteString// convert URL to String

                let post = ["pictureURL": urlString]
                self.dataManager.currentUserReference().updateChildValues(post)

                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "ProfilePicture")
            })
        })

        self.profilePicture.image = selectedPicture
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func openPhotos() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        //            let item = arr[indexPath.row]
        //            let itemSize = item.size(withAttributes: [
        //                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        //            ]).width + 30

        return  CGSize(width: arr[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23)]).width + 10, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sport = arr[indexPath.row]
        return tagContainer.collectionView(type: coordinator!.type , sport, collectionView, cellForRowAt: indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trainingCell", for: indexPath) as! UserTagCollectionViewCell
//        cell.sportLabel.text = arr[indexPath.row]

//                cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
//                cell.deleteButton.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)

        //return cell
    }
}

