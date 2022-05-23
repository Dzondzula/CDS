//
//  DataObjects.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 10.1.22..
//
import Firebase
import UIKit

class getDataManager {

  static  let rootRef = Database.database(url: "https://myfirebase-ee73a-default-rtdb.europe-west1.firebasedatabase.app").reference()
    static let userInfoRef = rootRef.child("user-informations")
    static let trainingScheduleRef = rootRef.child("training-schedule")
    
    
    static var infoRefObservers:[DatabaseHandle] = []
}
