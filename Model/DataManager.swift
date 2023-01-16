//
//  DataObjects.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.1.22..
//
import Firebase
import UIKit

class DataManager: MemberListDelegate {
    
    let rootRef = Database.database(url: "https://myfirebase-ee73a-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    var userInfoRef : DatabaseReference { rootRef.child("user-informations")
    }
    
    var trainingScheduleRef :DatabaseReference{ rootRef.child("training-schedule")
    }
    
    var infoRefObservers:[DatabaseHandle] = []
    
    
    
    func fetchMembers(completion: @escaping ([UserInfo]) -> Void) {
        
        userInfoRef.observe(.value){ snapshot,error in
            
            var newArray: [UserInfo] = []
            
            for child in snapshot.children{
                let snapshot = child as! DataSnapshot
                
                if  let dictionary = snapshot.value as? [String:Any]{
                    let username = dictionary["username"] as! String
                    let firstName = dictionary["firstName"] as! String
                    let lastName = dictionary["lastName"] as! String
                    let profilePic = dictionary["pictureURL"] as? String
                    let training = dictionary["Training"] as? [String]
                    let payments = dictionary["Payments"] as! [String: Any]
                    let isPaid = payments["isPaid"] as? Bool
                    
                    let uid = dictionary ["uid"] as! String
                    let admin = dictionary["isAdmin"] as! Bool
                    
                    let userInformation = UserInfo(firstName: firstName, lastName: lastName, username: username,pictureURL: profilePic,training: training, isPaid: isPaid, uid: uid, admin: admin)
                    newArray.append(userInformation)
                    
                    completion(newArray)
                    
                }
            }
        }
    }
    
    func isAdmin() -> Bool {
        var data : Bool = false
        let uid = Auth.auth().currentUser?.uid
        let child = userInfoRef.child(uid!)//add to service
        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                data = (snapshot.value as? Bool ?? false)
            }
            
        })
        return data
    }
    func checkPaymentStatus(){
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists(){
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let keyy = snap.key
                    
                    self.userInfoRef.child(keyy).child("Payments").observeSingleEvent(of: .value, with: {
                        snapshot in
                        let dict = snapshot.value as! [String:Any]
                        if let endDate = dict["endDate"] as? String{
                            
                            let today = Calendar.current.dateComponents(in: .current, from: Date())
                            let todayDate = Calendar.current.date(from: today)
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "d. MMMM yyyy."
                            formatter.timeZone = TimeZone(identifier: "Europe/Belgrade")
                            
                            let endDay = formatter.date(from: endDate )
                            
                            if todayDate! > endDay! {
                                let value: Bool = false
                                let post = ["isPaid": value]
                                self.userInfoRef.child(keyy).child("Payments").updateChildValues(post)
                            } else {
                                print("Still active")
                            }
                        }
                        //                let unitFlags = Set<Calendar.Component>([ .second])
                        //                let datecomponents = Calendar.current.dateComponents(unitFlags, from: date1!, to: date2!)
                        //                let secondsLeft = Double(datecomponents.second!)
                        
                    })
                    
                }
            } else{
                print("Nothing has been found")
            }
        })
    }
}
