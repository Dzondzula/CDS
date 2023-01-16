//
//  UserInfo.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 8.1.22..
//
import Firebase
import Foundation
import UIKit


struct UserInfo{
    let ref: DatabaseReference?
    let key: String
    let firstName: String
    let lastName: String
    let username: String
    let pictureURL : String?
    let training : [String]?
    var isPaid : Bool?
    let uid: String
    let admin: Bool
    
    init(firstName: String, lastName:String,username:String,pictureURL:String?,training:[String]?,isPaid:Bool?,uid:String,admin:Bool, key:String = "" ){
        self.ref = nil
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = pictureURL
        self.training = training
        self.isPaid = isPaid
        self.uid = uid
        self.admin = admin
        
    }
    
    init?(snapshot: DataSnapshot){
        guard let value = snapshot.value as? [String:AnyObject],
              let firstName = value["firstName"] as? String,
              let lastName = value["lastName"] as? String,
              let username = value["userName"] as? String,
              let profilePic = value["pictureURL"] as? String,
              let training = value["Training"] as? [String],
              let isPaid = value["isPaid"] as? Bool,
              let uid = value["uid"] as? String,
              let admin = value["isAdmin"] as? Bool
                
        else {return nil}
    
        self.ref = nil
        self.key = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = profilePic
        self.training = training
        self.isPaid = isPaid
        self.uid = uid
        self.admin = admin
    }
    
    func toAnyObject()-> Any{
        return [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "pictureURL":pictureURL as Any,
            "Training": training as Any,
            "uid": uid,
            "isAdmin": admin
        ]
    }

}

