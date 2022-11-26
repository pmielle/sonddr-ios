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
    @Published var loggedInUser: User?
    
    
    // constructor
    // ------------------------------------------
    init(loggedInUser: User? = nil) {
        self.loggedInUser = loggedInUser
    }
    
    
    // methods
    // ------------------------------------------
    func logIn() {
        self.loggedInUser = dummyUser()
    }
    
    func logOut() {
        self.loggedInUser = nil
    }
}
