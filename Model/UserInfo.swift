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
    let key: String?
    let firstName: String?
    let lastName: String?
    let username: String?
    let pictureURL : String?
    
    init(firstName: String, lastName:String,username:String,pictureURL:String?, key:String? = "" ){
        self.ref = nil
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = pictureURL
        
    }
    
    init?(snapshot:DataSnapshot){
        guard let value = snapshot.value as? [String:AnyObject],
              let firstName = value["firstName"] as? String,
              let lastName = value["lastName"] as? String,
              let username = value["userName"] as? String,
              let profilePic = value["pictureURL"] as? String
        else {return nil}
    
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pictureURL = profilePic
    }
    func toAnyObject()-> Any{
        return [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "pictureURL":pictureURL
        ]
    }

}

