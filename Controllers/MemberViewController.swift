//
//  UserProfileViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import SwiftCheckboxDialog
import FirebaseStorage
import Firebase
import UIKit

class MemberViewController: UIViewController,UINavigationControllerDelegate,CheckboxDialogViewDelegate {
    
    //    lazy var storage = Storage.storage().reference(withPath: "images/\(uid!)")
    //    var informations: [UserInfo] = []
    //    var user: User?
    //    var handle: AuthStateDidChangeListenerHandle?
    //
    //    var refObserver:[DatabaseHandle] = []
    
    var arr : [String] = []
    var detailItem : UserInfo?
    var checkboxDialogViewController: CheckboxDialogViewController!
    
    //define typealias-es
    typealias TranslationTuple = (name: String, translated: String)
    typealias TranslationDictionary = [String : String]
    
    
    
    lazy var collectionView :UICollectionView = {
        let layout = TagFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 10
        
        
        
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        
       // cv.collectionViewLayout = TagFlowLayout
        cv.delegate = self
        cv.dataSource = self
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "trainingCell")
        cv.layer.cornerRadius = 13.0
        cv.layer.masksToBounds = true
        cv.backgroundColor = .black
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
        
    }()
    lazy var containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .black
        cv.layer.cornerRadius = 8.0
        cv.layer.masksToBounds = true
        cv.addSubview(profilePicture)
        cv.addSubview(trainings)
        profilePicture.isUserInteractionEnabled = true
        // let pictureTap = UITapGestureRecognizer(target: self, action: #selector(pictureTapped))
        //profilePicture .addGestureRecognizer(pictureTap)
        
        NSLayoutConstraint.activate([
            profilePicture.centerXAnchor.constraint(equalTo: cv.centerXAnchor),
            profilePicture.centerYAnchor.constraint(equalTo: cv.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            profilePicture.heightAnchor.constraint(equalToConstant: 120),
            trainings.bottomAnchor.constraint(equalTo: profilePicture.topAnchor),
            trainings.rightAnchor.constraint(equalTo: cv.rightAnchor,constant: -10),
            trainings.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        cv.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: cv.centerXAnchor),
            
        ])
        
        profilePicture.layer.cornerRadius = 120/2
        nameLabel.text = "Car Dušan Silni"
        
        return cv
    }()
    
    lazy var profilePicture: UIImageView = {
        let picture = UIImageView()
        picture.backgroundColor = .brown
        picture.image = UIImage(named: "CDS")
        picture.contentMode = .scaleAspectFill
        picture.clipsToBounds = true
        picture.layer.borderWidth = 2
        picture.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        picture.translatesAutoresizingMaskIntoConstraints = false
        
        
        return picture
        
    }()
    
    let trainings : UIButton = {
       let tr = UIButton()
        tr.translatesAutoresizingMaskIntoConstraints = false
        tr.setTitle("Change training", for: .normal)
        tr.addTarget(self, action: #selector(editTraining), for: .touchUpInside)
        

        return tr
    }()
    
    
    let nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .white
        return name
    }()
    
    lazy var paymentView :UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13.0
        view.layer.masksToBounds = true
        view.layer.shadowRadius = 7.0
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        
        
        view.layer.shadowOpacity = 0.10
        
        // How far the shadow is offset from the UICollectionViewCell’s frame
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.backgroundColor = .black
        view.addSubview(paymentViewTitle)
        view.addSubview(paymentStatusPicture)
        view.addSubview(paymentStatusLabel)
        view.addSubview(trainingPriceLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentViewTitle.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            paymentViewTitle.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            
            trainingPriceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trainingPriceLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30),
            
            paymentStatusPicture.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paymentStatusPicture.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20),
            paymentStatusPicture.widthAnchor.constraint(equalToConstant: 120),
            paymentStatusPicture.heightAnchor.constraint(equalToConstant: 120),
            
            paymentStatusLabel.topAnchor.constraint(equalTo: paymentStatusPicture.bottomAnchor,constant: 10),
            paymentStatusLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
        ])
        return view
    }()
    
    lazy var paymentStatusPicture: UIImageView = {
        let picture = UIImageView()
        picture.image = UIImage(named: "unpaid")
        picture.contentMode = .scaleAspectFill
        picture.clipsToBounds = true
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.isUserInteractionEnabled = true
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(paymentTapped))
        picture .addGestureRecognizer(pictureTap)
        return picture
        
    }()
    
    lazy var paymentStatusLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nije placeno"
        label.textColor = .white
        return label
    }()
    lazy var trainingPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00,00"
        label.textAlignment = .justified
        label.textColor = .white
        
        return label
    }()
    
    lazy var paymentViewTitle : UILabel = {
        let label = UILabel()
        label.text = "Training status"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let editTraining = UIBarButtonItem(title: "Training", style: .plain, target: self, action: #selector(editTraining))
        self.navigationItem.rightBarButtonItem = editTraining
        view.backgroundColor = .white
        
        
        view.addSubview(containerView)
        //        self.roundCorners(view: containerView, corners: [.bottomLeft, .bottomRight], radius: 10)
        view.addSubview(collectionView)
        view.addSubview(paymentView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/3),
            
            paymentView.topAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 15),
            paymentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            paymentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            paymentView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/3),
            
            collectionView.topAnchor.constraint(equalTo: paymentView.bottomAnchor,constant: 15),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1/4)
            
            
            
        ])
        
        guard let detailItem = detailItem else {
            return
        }
        
        self.nameLabel.text = detailItem.username
        
        DispatchQueue.main.async {
            guard let training = detailItem.training else {return }
            self.arr = training
            self.collectionView.reloadData()
        }
        
        if let picture = detailItem.pictureURL,
           let url = URL(string: picture){
            self.profilePicture.loadImage(url: url)
        }
        let child = getDataManager.userInfoRef.child(detailItem.uid)//add to service
        let child2 = child.child("Payments")
        child2.observeSingleEvent(of: .value, with: { [self](snapshot) in
            if snapshot.exists(){
                
                    let dict = snapshot.value as! [String:Any]
                    let isPaid = dict["isPaid"] as? Bool
                   if let startDate = dict["startDate"] as? String,
                      let endDate = dict["endDate"] as? String{
                    if isPaid == true{
                        paymentStatusPicture.image = UIImage(named: "paid")
                        paymentStatusLabel.text = "Activated: \(String(describing: startDate))"
                    } else{
                        paymentStatusPicture.image = UIImage(named: "unpaid")
                        paymentStatusLabel.text = "Expired on: \(String(describing: endDate))"
                    }
                   }
            } else{
                print(" does not exist")
            }
//            let data = snapshot.value as? Bool
//            if data == true{
//                paymentStatusPicture.image = UIImage(named: "paid")
//                paymentStatusLabel.text = "Active"
//            } else {
//                paymentStatusPicture.image = UIImage(named: "unpaid")
//                paymentStatusLabel.text = "Expired"
//            }
        })
        
        child2.child("Price").observeSingleEvent(of: .value, with: { [self](snapshot) in
            if snapshot.exists(){
                let data = snapshot.value as! Int
                trainingPriceLabel.text = "\(data),00 RSD"
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        
    }
    
    @objc func editTraining(){
        
        let tableData :[(name: String, translated: String)] = [("MMA", "4000"),
                                                               ("Box", "3500"),
                                                               ("Kick-box", "3500"),
                                                               ("Jiu-jitsu", "3500"),
                                                               ("Wrestling", "3000"),
                                                               ("Karate", "3000"),
                                                               ("Krav-maga", "4000")]
        
        
        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "All sports"
        self.checkboxDialogViewController.tableData = tableData
        //self.checkboxDialogViewController.defaultValues = [tableData[3]]
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.countries
        self.checkboxDialogViewController.delegateDialogTableView = self
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
        
    }
    
    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        let myKeys: [String] = values.map{String($0.key) }
        let combined = Array(Set(myKeys + arr))
        arr = combined
        let unpaid:Bool = false
        
        let sum =  values.compactMap{Int($0.value)}.reduce(0, +)
        trainingPriceLabel.text = "\(sum),00 RSD"
        
        guard let detailItem = detailItem else {
            return
        }
        
        let ref = getDataManager.userInfoRef.child(detailItem.uid)
        DispatchQueue.global(qos: .background).async { [self] in
            let post = ["Training":arr]
            ref.updateChildValues(post)
            let ref2 = ref.child("Payments")
            let post2 = ["isPaid":unpaid]
            ref2.updateChildValues(post2)
            
            let post3 = ["Price":sum]
            ref2.updateChildValues(post3)
        }
        
        collectionView.reloadData()
        
        
        
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing{
            
        }
    }
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
}



extension MemberViewController:   UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

extension MemberViewController {
    @objc func deleteTapped(_ sender: UIButton) {
        guard let index : Int = (sender.layer.value(forKey: "index")) as? Int else {return}
        arr.remove(at: index)
        guard let detailItem = detailItem else {
            return
        }
        
        let ref = getDataManager.userInfoRef.child(detailItem.uid)
        let post = ["Training":arr]
        ref.updateChildValues(post)
        collectionView.reloadData()
    }
    
    @objc func paymentTapped(){
        
        guard let detailItem = detailItem else {
            return
        }
        let child = getDataManager.userInfoRef.child(detailItem.uid)//add to service
        let child2 = child.child("Payments")
        child2.child("isPaid").observeSingleEvent(of: .value, with: { [self](snapshot) in
            if snapshot.exists(){
                let data = snapshot.value as! Bool
                var changed = !data
                
                if changed == true{
                    //paymentStatusLabel.text = "Active until: \(endString)"
                    let startDate = Calendar.current.dateComponents(in: .current, from: Date())
                    let expireDate = DateComponents( year: startDate.year, month: startDate.month, day: startDate.day! + 1, hour: startDate.hour, minute: startDate.minute, second: startDate.second )
                   if let dateS = Calendar.current.date(from: startDate),
                      let dateE = Calendar.current.date(from: expireDate){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d. MMMM yyyy."
                    let startString = formatter.string(from: dateS)
                    let endString = formatter.string(from: dateE)
                       let post = ["startDate": startString,
                                   "endDate": endString]
                       child2.updateChildValues(post)
                       paymentStatusPicture.image = UIImage(named: "paid")
                       paymentStatusLabel.text = "Active until: \(endString)"
//                 let myQuery = child2.queryStarting(atValue: startString).queryEnding(atValue: endString)
//                       myQuery.observeSingleEvent(of: .value, with: { snapshot in
//                           for child in snapshot.children{
//                               let snap = child as! DataSnapshot
//                               let dict = snap.value as! [String: Any]
//                               let sd = dict["startDate"] as! String
//                               let ed = dict["endDate"] as! String
//                               let date1 = formatter.date(from: sd)
//                               let date2 = formatter.date(from: ed)
//                               let unitFlags = Set<Calendar.Component>([ .second])
//                               let datecomponents = Calendar.current.dateComponents(unitFlags, from: date1!, to: date2!)
//                               let secondsLeft = Double(datecomponents.second!)
//                               var timer = Timer()
//                               timer = Timer.scheduledTimer(timeInterval: secondsLeft, target: self, selector: #selector(updatePayment), userInfo: nil, repeats: false)
//
//
//                           }
//                       })
                    
                   }
                    
                } else if changed == false{
                    paymentStatusPicture.image = UIImage(named: "unpaid")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d, MMM yyyy"
                    let date = Date()
                    let today = formatter.string(from: date)
                    paymentStatusLabel.text = "Expired: \(today)"
                }
                
                let post = ["isPaid":changed]
                child2.updateChildValues(post)
                
            }
            
        })
        
        
    }
    func daysDiff(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)

        let a = calendar.dateComponents([.second], from: date1, to: date2)
        return a.value(for: .second)!
    }
    @objc func updatePayment(){
        
        let value: Bool = false
            let post = ["isPaid":value]
        let child = getDataManager.userInfoRef.child(detailItem!.uid)//add to service
        let child2 = child.child("Payments")
        child2.updateChildValues(post)
    }
}

