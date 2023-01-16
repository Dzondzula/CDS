//
//  MemberCellSwiftUI.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 16.1.23..
//

import SwiftUI

struct MemberCellSwiftUI: View {
    var member : MembersRepresentable
    var body: some View {
        Text(member.name)
    }
}

struct MemberCellSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellSwiftUI(member: MemberCellViewModel(user: UserInfo(firstName: "SKr", lastName: "Gra", username: "", pictureURL: "", training: [""], isPaid: false, uid: "", admin: false)))
    }
}
