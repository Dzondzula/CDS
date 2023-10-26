//
//  UserInfo.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Firebase
import Foundation
import UIKit
// Firebase returns a FIRDataSnapshot that can't be decodable.

struct UserInfo {

    let key: String?
    let firstName: String
    let lastName: String
    let username: String
    let pictureURL: String?
    let training: [String]?
    let Payments: PaymentsData?
    let uid: String
    let admin: Bool


    init(key: String? = "", firstName: String, lastName: String, username: String, pictureURL: String?, training: [String]?, Payments: PaymentsData?, uid: String, admin: Bool) {
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = pictureURL
        self.training = training
        self.Payments = Payments
        self.uid = uid
        self.admin = admin
    }

    init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any],
              let uid = dictionary ["uid"] as? String,
              let admin = dictionary["isAdmin"] as? Bool,
              let username = dictionary["username"] as? String,
              let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String
        else { fatalError()}
        let profilePic = dictionary["pictureURL"] as? String
        let training = dictionary["Training"] as? [String]
        let paymentsData = dictionary["Payments"] as? [String: Any]
              let price = paymentsData?["Price"] as? Int
              let startDate = paymentsData?["startDate"] as? String
              let endDate = paymentsData?["endDate"] as? String
              let isPaid = paymentsData?["isPaid"] as? Bool

        let payments = PaymentsData(Price: price ?? 0, endDate: endDate ?? "", isPaid: isPaid ?? false, startDate: startDate ?? "")
        self.key = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = profilePic
        self.training = training
        self.Payments = payments
        self.uid = uid
        self.admin = admin
    }

    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "pictureURL": pictureURL as Any,
            "Training": training as Any,
            "uid": uid,
            "isAdmin": admin
        ]
    }
}

struct PaymentsData {
    let Price: Int
    let endDate: String
   let isPaid: Bool
    let startDate: String
}
