//
//  MemberTableViewModel.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 16.12.22..
//
import UIKit
import Foundation

class MemberTableViewModel {
    var members: [UserInfo] = []

    func memberImgUrl(for index: Int) -> URL {
        let user = members[index]
        if let picture = user.pictureURL,
           let url = URL(string: picture) {
            return url
        } else {return URL(string: "")!
        }
    }

//    func name(for index : Int) -> String{
//        let user = members[index]
//        return user.firstName
//    }

    func training(for index: Int) -> String? {
        let user = members[index]
        guard let userT = user.trainings else {return nil}
        return userT.first
    }

//    func isPaid(for index : Int) -> Bool?{
//        let user = members[index]
//        return user.isPaid
//        }

    func memberViewModel(users: [UserInfo], for index: Int) -> MemberCellViewModel {
        return MemberCellViewModel(user: users[index])
    }
}

struct MemberCellViewModel: MembersRepresentable {

    var user: UserInfo
    var dateFormatter = DateFormatter()
    var isAdmin: Bool {
        return user.admin
    }

    var isPaid: Bool {
        return user.Payments?.isPaid ?? false
    }

    var startDate: String {
        return user.Payments?.startDate ?? "N/A"
    }
    var endDate: String {
        return user.Payments?.endDate ?? "N/A"
    }



    var imageUrl: URL {
        if let userPicUrl = user.pictureURL {
            return URL(string: userPicUrl)!
        } else {
            return URL(string: "")!
        }
    }

    var name: String {
        return user.firstName
    }

    var lastName: String {
        return user.lastName
    }

    var trainings: [String] {
        return user.trainings ?? [""]
    }
}

protocol MembersRepresentable {
    var imageUrl: URL {get}
    var name: String {get}
    var trainings: [String] {get}
    var isPaid: Bool {get}
    var isAdmin: Bool {get}
    var lastName: String {get}
    var endDate: String {get}
    var startDate: String {get}
}
