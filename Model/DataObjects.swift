//
//  DataObjects.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.1.22..
//
import Firebase
import UIKit

class DataObjects {

  static  let rootRef = Database.database(url: "https://myfirebase-ee73a-default-rtdb.europe-west1.firebasedatabase.app").reference()
    static let infoRef = rootRef.child("user-informations")
    
    
    
    static var infoRefObservers:[DatabaseHandle] = []
}
