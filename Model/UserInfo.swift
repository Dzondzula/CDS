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
    let uid: String
    let admin: Bool
    
    init(firstName: String, lastName:String,username:String,pictureURL:String?,training:[String]?,uid:String,admin:Bool, key:String = "" ){
        self.ref = nil
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = pictureURL
        self.training = training
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
              let uid = value["uid"] as? String,
              let admin = value["isAdmin"] as? Bool
                
        else {return nil}
    
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = profilePic
        self.training = training
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

