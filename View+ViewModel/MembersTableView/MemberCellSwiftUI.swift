//
//  MemberCellSwiftUI.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 16.1.23..
//
import UIKit
import SwiftUI

struct MemberCellSwiftUI2: View {
    var member: MembersRepresentable

    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: member.imageUrl) {image in

                image.resizable().transition(.opacity.combined(with: .scale)).frame(width: 90, height: 90).scaledToFit().cornerRadius(15)
            } placeholder: { Image("CDS").resizable().transition(.opacity.combined(with: .scale)).frame(width: 90, height: 90).scaledToFit().cornerRadius(15) }
        ZStack(alignment: .trailing) {
            HStack(spacing: 0) {
//                AsyncImage(url: member.imageUrl) {image in
//
//                    image.resizable().transition(.opacity.combined(with: .scale)).frame(width: 64, height: 64).cornerRadius(16)
//                } placeholder: { Image("CDS").resizable().transition(.opacity.combined(with: .scale)).frame(width: 64, height: 64).cornerRadius(16) }

                VStack(alignment: .leading, spacing: 4.0) {
                    Text(member.name + " " + member.lastName)
                        .fontWeight(.bold)
                        .font(.headline).dynamicTypeSize(.large)

                    Text(member.isPaid ? String("Active: \(member.startDate)").dropLast(5) : String("Expired: \(member.endDate)").dropLast(5))
                        .lineLimit(1)
                        .font(.subheadline).dynamicTypeSize(.medium)
                        .foregroundColor(Color(uiColor: .gray))
                }

                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            }.padding(.bottom, 10)

            VStack {
                Spacer()
                Text(member.trainings.first?.uppercased() ?? "")
                    .font(.headline).dynamicTypeSize(.large).padding(.trailing, 10)
            }
        }.frame(height: 90)
    }
    }
}

struct MemberCellSwiftUI: View {
    var member: MembersRepresentable

    var body: some View {
        ZStack {


            MemberCellSwiftUI2(member: member).background(LinearGradient(stops: [.init(color: .white, location: 0.75), .init(color: member.isPaid ? .gray : .red, location: 0.8)], startPoint: .topLeading, endPoint: .init(x: 0.9, y: 1.7)).overlay(.ultraThinMaterial))
        }
        .cornerRadius(12.0)
        .padding()
        .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellSwiftUI(member: MemberCellViewModel(user: UserInfo(firstName: "Nikola", lastName: "Andrijasevic", username: "dzondzula", pictureURL: "picture", training: [ "mma"], Payments: PaymentsData(Price: 100, endDate: "01.JUN 2222", isPaid: true, startDate: "01.JUN 2222"), uid: "", admin: false)))
    }
}
