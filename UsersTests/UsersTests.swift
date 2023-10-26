//
//  UsersTests.swift
//  UsersTests
//
//  Created by Nikola Andrijasevic on 3.5.22..
//

import XCTest
@testable import MyFirebase
import SnapshotTesting
class UsersTests: XCTestCase {

    var sut: MemebersViewController!

    override func setUp() {
        sut = MemebersViewController()
        sut.loadViewIfNeeded()
    }
    override func tearDown() {
        sut = nil
    }

    func testInitialLoginScreen() {
        setUsers()

        assertSnapshot(matching: sut, as: .image, record: true)
    }

    func setUsers() {
        for number in 0...5 {
            let user = UserInfo(firstName: "Nikola", lastName: "Andr", username: "lol", pictureURL: nil, training: ["mjau", "idegasara"], isPaid: false, uid: "\(number)", admin: false)
            sut.users.append(user)
        }
    }
}
