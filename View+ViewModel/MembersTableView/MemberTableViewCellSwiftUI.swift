//
//  MemberTableViewCellSwiftUI.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 16.1.23..
//
import SwiftUI
import UIKit
import Foundation

class MemberTableViewCellSwiftUI: UITableViewCell {

    init(member: MembersRepresentable) {
        super.init(style: .default, reuseIdentifier: "userCell")
        let vc = UIHostingController(rootView: MemberCellSwiftUI(member: member))
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        vc.view.backgroundColor = .clear

        selectionStyle = .default
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemGray6
    }
}
