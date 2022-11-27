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
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { Color("PrimaryColor").ignoresSafeArea()
            VStack(spacing:myLargeSpacing) {
                Text("sonddr is a place to share and contribute to each other ideas to make the world a little (or a lot) better")
                    .myTitle()
                VStack(spacing: mySpacing) {
                    Button("Log in") {
                        withAnimation {  // fade from this view to main
                            self.auth.logIn()
                        }
                    }
                    .myLargeButton(color: Color("GreenColor"))
                    Button("Sign up") {
                        print("click")
                    }
                    .myLargeButton(color: .white.opacity(0.5))
                }
            }
            .myGutter()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NavigationView {
            LoginView()
                .environmentObject(auth)
                .environmentObject(db)
        }
    }
}
