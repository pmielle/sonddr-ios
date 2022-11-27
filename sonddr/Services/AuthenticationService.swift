//
//  AuthenticationService.swift
//  sonddr
//
//  Created by Paul Mielle on 26/11/2022.
//

import SwiftUI

class AuthenticationService: ObservableObject {
    
    // attributes
    // ------------------------------------------
    let db: DatabaseService
    @Published var loggedInUser: User?
    
    
    // constructor
    // ------------------------------------------
    init(db: DatabaseService, testMode: Bool = false) {
        self.db = db
        self.loggedInUser = testMode ? db.getUser() : nil
    }
    
    
    // methods
    // ------------------------------------------
    func logIn() {
        self.db.loggedInUserToken = "TOKEN"
        self.loggedInUser = self.db.getUser()
    }
    
    func logOut() {
        self.loggedInUser = nil
    }
}
