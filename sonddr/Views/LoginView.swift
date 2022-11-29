//
//  LoginView.swift
//  sonddr
//
//  Created by Paul Mielle on 24/11/2022.
//

import SwiftUI

struct LoginView: View {

    // attributes
    // ------------------------------------------
    @EnvironmentObject var auth: AuthenticationService
    @State var isLoading = false
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { Color("PrimaryColor").ignoresSafeArea()
            VStack(spacing:myLargeSpacing) {
                Text("sonddr is a place to share and contribute to each other ideas to make the world a little (or a lot) better")
                    .myTitle()
                VStack(spacing: mySpacing) {
                    self.loginButton()
                    self.signupButton()
                }
            }
            .myGutter()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func loginButton() -> some View {
        Button("Log in") {
            self.onLoginClick()
        }
        .myLargeButton(color: Color("GreenColor"))
        .disabled(self.isLoading)
    }
    
    func signupButton() -> some View {
        Button("Sign up") {
            print("click")
        }
        .myLargeButton(color: .white.opacity(0.5))
        .disabled(self.isLoading)
    }
    
    
    // methods
    // ------------------------------------------
    func onLoginClick() {
        Task {
            self.isLoading = true
            do {
                try await self.auth.logIn()
            } catch {
                print("an error occured: \(error)")  // TODO: in a snack bar
                self.isLoading = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NavigationStack {
            LoginView()
                .environmentObject(auth)
                .environmentObject(db)
        }
    }
}
