//
//  MemberTableViewModel.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 16.12.22..
//
import UIKit
import Foundation

struct MemberTableViewModel{
    let members: [UserInfo]
    
    func memberImgUrl(for index : Int) -> URL{
        let user = members[index]
        if let picture = user.pictureURL,
           let url = URL(string: picture){
            return url
            
        } else {return URL(string:"")!
            
        }
    }
    
//    func name(for index : Int) -> String{
//        let user = members[index]
//        return user.firstName
//    }
    
    func training(for index: Int)-> String?{
        let user = members[index]
        guard let userT = user.training else {return nil}
        return userT.first
    }
    
//    func isPaid(for index : Int) -> Bool?{
//        let user = members[index]
//        return user.isPaid
//        }
    
    func memberViewModel(for index: Int) -> MemberCellViewModel{
        return MemberCellViewModel(user: members[index])
    }
                                                      
    
}

struct MemberCellViewModel: MembersRepresentable{
    var isAdmin: Bool {
        return user.admin
    }
    
    var isPaid: Bool{
        return user.isPaid ?? false
    }
    
    var imageUrl: URL{
        if let userPicUrl = user.pictureURL{
            return URL(string:userPicUrl)!
        } else{
            return URL(string:"")!
        }
    }
    
    var name: String{
        return user.firstName
    }
    
    var training: String{
        return user.training?.first ?? ""
    }
    
    var user : UserInfo
    
}


protocol MembersRepresentable{
    var imageUrl: URL {get}
    var name: String {get}
    var training: String {get}
    var isPaid:Bool {get}
    var isAdmin : Bool{get}
}
