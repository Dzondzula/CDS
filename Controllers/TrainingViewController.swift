//
//  ViewController.swift
//  spotifyAutoLayout
//
//  Created by admin on 10/31/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//
import Firebase
import UIKit

class TrainingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,DialogViewDelegate {
    
    
    
    func onCheckboxPickerValueChanged(_ trainingType: String, _ time: String){
        let chooseDay = UIAlertController(title: "Add training", message: "Choose day", preferredStyle: .actionSheet)
        for (index, weekdays) in sections.enumerated(){
            chooseDay.addAction(UIAlertAction(title: weekdays.weekDay, style: .default){[weak self]_ in
                guard let self = self else {return}
                                   let newTraining = Training(title: trainingType, image: trainingType)
                                   self.sections[index].training.append(newTraining)
                                   let indexPath = IndexPath(item: 0, section: 0)
                self.collectionView.insertItems(at: [indexPath])
                })
        }
            let cancle = UIAlertAction(title: "Cancel", style: .destructive)
            cancle.setValue(UIColor.red, forKey: "titleTextColor")
            chooseDay.addAction(cancle)
        present(chooseDay,animated: true)
    
    }
    
    let cellId : String = "cellId"
    var sections = TrainingAPI.getTraining()
    var dialogViewController: DialogViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addTraining = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTraining))
        //addTraining.frame = CGRect(x:0, y:0, width:32, height:32)
        let uid = Auth.auth().currentUser?.uid
        let child = DataObjects.infoRef.child(uid!)//add to service
        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as? Bool
            if data == true{
        self.tabBarController!.navigationItem.rightBarButtonItems = [addTraining]
        //self.navigationController?.hidesBarsOnSwipe = true
            } else {
                self.tabBarController!.navigationItem.rightBarButtonItems = []
                self.tabBarController?.navigationController?.isNavigationBarHidden = true
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        collectionView.backgroundColor = .purple
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
                layout.minimumInteritemSpacing = 5.0
                layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
                collectionView!.collectionViewLayout = layout
//        fetchJson()

    }
    init(){
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
        
        return cell
    }
    
    @objc func addTraining(){
                
                self.dialogViewController = DialogViewController()
                self.dialogViewController.titleDialog = "Countries"
                self.dialogViewController.delegateDialogViews = self
                self.dialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
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

