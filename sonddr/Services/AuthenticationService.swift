//
//  AuthenticationService.swift
//  sonddr
//
//  Created by Paul Mielle on 26/11/2022.
//

import SwiftUI

@MainActor
class AuthenticationService: ObservableObject {
    
    // attributes
    // ------------------------------------------
    let db: DatabaseService
    @Published var loggedInUser: User?
    
    
    // constructor
    // ------------------------------------------
    init(db: DatabaseService, testMode: Bool = false) {
        self.db = db
        self.loggedInUser = testMode ? dummyUser() : nil
    }
    
    
    // methods
    // ------------------------------------------
    func logIn() async throws {
        self.db.loggedInUserToken = "TOKEN"
        self.loggedInUser = try await self.db.getUser()
    }
    
    func logOut() async {
        self.loggedInUser = nil
    }
}
