//
//  DataObjects.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.1.22..
//
import Firebase
import UIKit
import FirebaseStorage
import Combine

class ClientManager: MemberListDelegate {

    var currentUserUid: String?
    var cancelable = Set<AnyCancellable>()
   static let rootRef = Database.database(url: "https://myfirebase-ee73a-default-rtdb.europe-west1.firebasedatabase.app").reference()

    static var userInfoRef: DatabaseReference { rootRef.child("user-informations")
    }

    static var trainingScheduleRef: DatabaseReference { rootRef.child("training-schedule")
    }

    var currentUser: UserInfo?


    var infoRefObservers: [DatabaseHandle] = []

    init?(currentUserUid: String) {
        self.currentUserUid = currentUserUid
    }

    func currentUserReference () -> DatabaseReference {
        guard let uid = currentUserUid else {fatalError()}
        return ClientManager.userInfoRef.child(uid)
    }

    func storageRef(to path: String) -> StorageReference {
        return Storage.storage().reference(withPath: "\(path)/\(currentUserUid!)")
    }
    func fetchMembers(completion: @escaping ([UserInfo]) -> Void) {

        ClientManager.userInfoRef.observe(.value) { snapshot, _ in

            var newArray: [UserInfo] = []

            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else {return}

                let user = UserInfo(snapshot: snapshot)
                newArray.append(user!)

                    completion(newArray)
            }
        }
    }

//    func fetchCurrentUser(user uid: String) -> AnyPublisher <UserInfo, Never> {
//
//            return Future<UserInfo, Never> {promise in
//                self.fetchUser(uid: uid) { result, _ in
//                    promise(.success(result))
//                }
//            }
//            .eraseToAnyPublisher()
//            .handleEvents(receiveOutput: { [weak self] value in
//                self?.currentUser.send(value)
//            }).eraseToAnyPublisher()
//    }


    func fetchUser(completition: @escaping (UserInfo,Error?)-> Void) {
        let user = Auth.auth().currentUser
      let ref =  ClientManager.userInfoRef.child(user!.uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
print("")
                let user = UserInfo(snapshot: snapshot as DataSnapshot)
                self.currentUser = user!
                completition(user!, nil)
            })
    }

    func currentUserInformations() async -> UserInfo {
        typealias UserContinuation = CheckedContinuation<UserInfo, Never>
    return await withCheckedContinuation { (continuation: UserContinuation) in
        self.fetchUser { (user, error) in
                continuation.resume(returning: user)

        }
    }
}

    func isAdmin() -> Bool {
        var data: Bool = false
        let uid = Auth.auth().currentUser?.uid
        let child = ClientManager.userInfoRef.child(uid!)
        print(child)// add to service
        child.child("isAdmin").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if snapshot.exists() {
                data = (snapshot.value as? Bool ?? false)
            }
        })
        return data
    }
    func checkPaymentStatus() {
        ClientManager.userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let keyy = snap.key

                    ClientManager.userInfoRef.child(keyy).child("Payments").observeSingleEvent(of: .value, with: {snapshot in
                        let dict = snapshot.value as! [String: Any]
                        if let endDate = dict["endDate"] as? String {

                            let today = Calendar.current.dateComponents(in: .current, from: Date())
                            let todayDate = Calendar.current.date(from: today)

                            let formatter = DateFormatter()
                            formatter.dateFormat = "d. MMMM yyyy."
                            formatter.timeZone = TimeZone(identifier: "Europe/Belgrade")

                            let endDay = formatter.date(from: endDate )

                            if todayDate! > endDay! {
                                let value: Bool = false
                                let post = ["isPaid": value]
                                ClientManager.userInfoRef.child(keyy).child("Payments").updateChildValues(post)
                            } else {
                                print("Still active")
                            }
                        }
                        //                let unitFlags = Set<Calendar.Component>([ .second])
                        //                let datecomponents = Calendar.current.dateComponents(unitFlags, from: date1!, to: date2!)
                        //                let secondsLeft = Double(datecomponents.second!)

                    })
                }
            } else {
                print("Nothing has been found")
            }
        })
    }
}
