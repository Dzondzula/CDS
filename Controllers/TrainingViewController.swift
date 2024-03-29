//
//  ViewController.swift
//  spotifyAutoLayout
//
//  Created by admin on 10/31/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//
import Firebase
import UIKit

class TrainingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DialogViewDelegate {

    var dataManager: ClientManager!
    let cellId: String = "cellId"
    var sec = TrainingSections.getTraining()
    var sections = TrainingAPI.getTraining()
    var dialogViewController: DialogViewController!
    var informations: [TrainingSections] = []
    var array: [TrainingInfo] = []
    weak var coordinator: Coordinator!

    func onCheckboxPickerValueChanged(_ trainingType: String, _ time: String, day: (name: String, index: Int)) {

        let newTraining = TrainingInfo(title: trainingType, image: trainingType, time: time)

        ClientManager.trainingScheduleRef.child(day.name).child("sport\(sections[day.index].training.count)").updateChildValues(["name": "\(trainingType)",
                                                                                                                                 "time": time])
        self.sections[day.index].training.append(newTraining)
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.insertItems(at: [indexPath])
    }

    enum NetworkError: Error {
        case noDataAvailable
        case canNotProcessData
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addTraining = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTraining))
        // addTraining.frame = CGRect(x:0, y:0, width:32, height:32)
        dataManager.currentUserReference().child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in

            let data = snapshot.value as? Bool
            if data == true {
                self.navigationItem.rightBarButtonItems = [addTraining, self.editButtonItem]
                // self.navigationController?.hidesBarsOnSwipe = true
            } else {
                self.tabBarController!.navigationItem.rightBarButtonItems = []
                self.tabBarController?.navigationController?.isNavigationBarHidden = true
            }
        })
        }

    func fetch(completion: @escaping (Result<TrainingSections, NetworkError>) -> Void) {
        for (index, weekdays) in sections.enumerated() {
            ClientManager.trainingScheduleRef.child(weekdays.weekDay.description).observeSingleEvent(of: .value) { snapshot, _ in

                var newArray: [TrainingInfo] = []
                if  let dict = snapshot.value as? [String: [String: Any]] {

                    for (_, value) in dict {
                        let name = value["name"] as! String
                        let time = value["time"] as! String
                        let tr = TrainingInfo(title: name, image: name, time: time)
                        newArray.append(tr)
                        self.sections[index].training.append(tr)
                        self.collectionView.reloadData()
                    }
                }
                let array = TrainingSections(weekDay: weekdays.weekDay, training: newArray)
                // print(array)

//            var newArray: [String] = []
//                for child in snapshot.children{
//                    let childrenSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
//                    print(child)
//                    print(childrenSnapshot)
//                    guard let lol = childrenSnapshot.value["sport"] as? String else {return}
//                    guard let name = (childrenSnapshot.value as? NSDictionary)?["name"] as? String else {return}
//                        print("geng\(name)")
//                    guard let time = (childrenSnapshot.value as? NSDictionary)?["time"] as? String else {return}
                        // snapshot.value has the type Any?, so you need to cast it to the underlying type before you can subscript it. Since snapshot.value!.dynamicType is NSDictionary, use an optional cast as? NSDictionary to establish the type, and then you can access the value in the dictionary:
                   // let Day = TrainingSections(weekDay: weekdays.weekDay, training: [TrainingInfo(title: name, image: name, time: time)])
                    // print(Day)
                completion(.success(array))
                }

                // let time = dictionary["time0"] as! String

                // newArray.append(name)
               // print(newArray)

                // print(newArray)
            }
            completion(.failure(.canNotProcessData))
            }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .systemGray6
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        let layout = UICollectionViewFlowLayout()
        //                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        //                layout.minimumInteritemSpacing = 5.0
        //                layout.minimumLineSpacing = 5.0
        //        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
        collectionView!.collectionViewLayout = layout

        fetch { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success: break
            }
        }
    }
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(300)

        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell

        cell.section = sections[indexPath.item]
        cell.isEditing = isEditing

        return cell
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.isEditing = editing
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
            cell.isEditing = editing
        }
    }

    @objc func addTraining() {

        self.dialogViewController = DialogViewController()
        self.dialogViewController.titleDialog = "Add training"
        self.dialogViewController.delegateDialogViews = self
        self.dialogViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(self.dialogViewController, animated: false, completion: nil)
    }
}

//    func fetchJson (){
//        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
//            do{
//                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .alwaysMapped)
//                let jsonResult = try JSONDecoder().decode([Section].self, from: data)
//                self.sections = jsonResult
//                
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            } catch{
//                print("erorija")
//            }
//        }
//    }
