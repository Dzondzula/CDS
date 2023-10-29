//
//  UserProfileViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..

import SwiftCheckboxDialog
import FirebaseStorage
import Firebase
import UIKit

class MemberInfoViewController: UIViewController, CheckboxDialogViewDelegate {


    var dataManager: ClientManager!
    weak var coordinator: AdminMembersCoordinator?
    var arr: [String] = []
    var detailItem: UserInfo?
    var checkboxDialogViewController: CheckboxDialogViewController!

    // define typealias-es
    typealias TranslationTuple = (name: String, price: String)
    typealias TranslationDictionary = [String: String]

    lazy var  memberViewLayout: MemberInfoLayoutView = .init()


    override func loadView() {

        // self.navigationItem.setHidesBackButton(true, animated: true)
       view = memberViewLayout
        memberViewLayout.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.id)

        guard let detailItem = detailItem else {
            return
        }

            memberViewLayout.nameLabel.text = detailItem.username

        DispatchQueue.main.async {
            guard let training = detailItem.training else {return }
            self.arr = training
            self.memberViewLayout.collectionView.reloadData()
        }

        if let picture = detailItem.pictureURL,
           let url = URL(string: picture) {
            self.memberViewLayout.profilePicture.loadImage(url: url)
        }
        let child = ClientManager.userInfoRef.child(detailItem.uid)// add to service
        let child2 = child.child("Payments")
        child2.observeSingleEvent(of: .value, with: { [self](snapshot) in
            if snapshot.exists() {

                let dict = snapshot.value as! [String: Any]
                let isPaid = dict["isPaid"] as? Bool
                if let startDate = dict["startDate"] as? String,
                   let endDate = dict["endDate"] as? String {
                    if isPaid == true {
                        memberViewLayout.paymentStatusPicture.image = UIImage(named: "paid")
                        memberViewLayout.subscriptionStatusLabel.text = "Activated: \(String(describing: startDate))"
                    } else {
                        memberViewLayout.paymentStatusPicture.image = UIImage(named: "unpaid")
                        memberViewLayout.subscriptionStatusLabel.text = "Expired on: \(String(describing: endDate))"
                    }
                }
            } else {
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
            if snapshot.exists() {
                let data = snapshot.value as! Int
                memberViewLayout.trainingPriceLabel.text = "\(data),00 RSD"
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let editTrainingg = UIBarButtonItem(title: "Training", style: .plain, target: self, action: #selector(editTraining))
        coordinator?.rootViewController.navigationItem.rightBarButtonItem = editTrainingg
        memberViewLayout.collectionView.delegate = self
        memberViewLayout.collectionView.dataSource = self

        memberViewLayout.changeTraining.addTarget(self, action: #selector(editTraining), for: .touchUpInside)

         let pictureTap = UITapGestureRecognizer(target: self, action: #selector(paymentTapped))
memberViewLayout.paymentStatusPicture.addGestureRecognizer(pictureTap)
    }


    @objc func editTraining() {

        let tableData: [(name: String, translated: String)] = [("MMA", "4000"),
                                                               ("Box", "3500"),
                                                               ("Kick-box", "3500"),
                                                               ("Jiu-jitsu", "3500"),
                                                               ("Wrestling", "3000"),
                                                               ("Karate", "3000"),
                                                               ("Krav-maga", "4000")]

        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "All sports"
        self.checkboxDialogViewController.tableData = tableData
        // self.checkboxDialogViewController.defaultValues = [tableData[3]]
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.countries
        self.checkboxDialogViewController.delegateDialogTableView = self
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
    }

    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        let myKeys: [String] = values.map { String($0.key) }
        let combined = Array(Set(myKeys + arr))
        arr = combined
        let unpaid: Bool = false

        let sum = values.compactMap { Int($0.value) }.reduce(0, +)
        memberViewLayout.trainingPriceLabel.text = "\(sum),00 RSD"

        guard let detailItem = detailItem else {
            return
        }

        let ref = ClientManager.userInfoRef.child(detailItem.uid)
        DispatchQueue.global(qos: .background).async { [self] in
            let post = ["Training": arr]
            ref.updateChildValues(post)
            let ref2 = ref.child("Payments")
            let post2 = ["isPaid": unpaid]
            ref2.updateChildValues(post2)

            let post3 = ["Price": sum]
            ref2.updateChildValues(post3)
        }

        memberViewLayout.collectionView.reloadData()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
        }
    }
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
//        //coordinator?.signOutTapped()
//        //coordinator?.removeCoordinator()
//        //self.dismiss(animated: true)
//       // coordinator?.parentCoordinator?.endTabCoordinator()
//        if let nav = coordinator?.navController{
//           // nav.viewControllers.removeAll()
//            let isPopping = !nav.viewControllers.contains(self)
//            if isPopping{
//                print("Popped out")
//                print(nav.viewControllers.removeLast())
//            } else{
//                print("not popped")
//                print("\(nav.viewControllers.description.description)")
//                print(nav.viewControllers.count)
//            }
//        }
//
//    }

}

extension MemberInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: arr[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23)]).width + 40, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberTrainingCell", for: indexPath) as! TagCollectionViewCell
        cell.sportLabel.text = arr[indexPath.row]

        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)

        return cell
    }
}

extension MemberInfoViewController {
    @objc func deleteTapped(_ sender: UIButton) {
        guard let index: Int = (sender.layer.value(forKey: "index")) as? Int else {return}
        arr.remove(at: index)
        guard let detailItem = detailItem else {
            return
        }

        let ref = ClientManager.userInfoRef.child(detailItem.uid)
        let post = ["Training": arr]
        ref.updateChildValues(post)
        memberViewLayout.collectionView.reloadData()
    }

    @objc func paymentTapped() {

        guard let detailItem = detailItem else {
            return
        }
        let child = ClientManager.userInfoRef.child(detailItem.uid)// add to service
        let child2 = child.child("Payments")
        child2.child("isPaid").observeSingleEvent(of: .value, with: { [self](snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! Bool
                let changed = !data

                if changed == true {
                    // paymentStatusLabel.text = "Active until: \(endString)"
                    let startDate = Calendar.current.dateComponents(in: .current, from: Date())
                    let expireDate = DateComponents( year: startDate.year, month: startDate.month, day: startDate.day! + 1, hour: startDate.hour, minute: startDate.minute, second: startDate.second )
                   if let dateS = Calendar.current.date(from: startDate),
                      let dateE = Calendar.current.date(from: expireDate) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d. MMMM yyyy."
                    let startString = formatter.string(from: dateS)
                    let endString = formatter.string(from: dateE)
                       let post = ["startDate": startString,
                                   "endDate": endString]
                       child2.updateChildValues(post)
                       memberViewLayout.paymentStatusPicture.image = UIImage(named: "paid")
                       memberViewLayout.subscriptionStatusLabel.text = "Active until: \(endString)"
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
                } else if changed == false {
                    memberViewLayout.paymentStatusPicture.image = UIImage(named: "unpaid")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d, MMM yyyy"
                    let date = Date()
                    let today = formatter.string(from: date)
                    memberViewLayout.subscriptionStatusLabel.text = "Expired: \(today)"
                }

                let post = ["isPaid": changed]
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
    @objc func updatePayment() {

        let value: Bool = false
            let post = ["isPaid": value]
        let child = ClientManager.userInfoRef.child(detailItem!.uid)// add to service
        let child2 = child.child("Payments")
        child2.updateChildValues(post)
    }
}

extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async {
            [self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
