//
//  LoginTests.swift
//  LoginTests
//
//  Created by Nikola Andrijasevic on 18.4.22..
//

import XCTest
import SnapshotTesting
@testable import MyFirebase
class LoginTests: XCTestCase {

    var sut: LogInViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: LogInViewController.self))
        sut.loadViewIfNeeded()
    }
    override func tearDown() {
        sut = nil
    }
    
    func testLoginVC(){
        _ = LogInViewController.instantiate()
    }
    
    func testInitialLoginScreen(){
        tap(sut.login)
        
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testLogInButton(){
        let result = verifySnapshot(matching: sut.login, as: .image)
        XCTAssertNil(result)
    }
    func tap(_ button: UIButton){
        button.sendActions(for: .touchUpInside)
    }
}
