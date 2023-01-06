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
        self.largeButton(
            color: myGreenColor,
            text: "Log in",
            perform: self.onLoginClick
        )
        .disabled(self.isLoading)
    }
    
    func signupButton() -> some View {
        self.largeButton(
            color: .white.opacity(0.5),
            text: "Sign up",
            perform: self.onSignupClick
        )
        .disabled(self.isLoading)
    }
    
    func largeButton(color: Color, text: String, perform: @escaping () -> Void) -> some View {
        Button {
            perform()
        } label: {
            Text(text)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(color)
                .cornerRadius(20)
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onSignupClick() {
        print("sign up...")
    }
    
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
