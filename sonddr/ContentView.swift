//
//  ContentView.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    // attributes
    // ------------------------------------------
    @ObservedObject var auth: AuthenticationService
    @ObservedObject var db: DatabaseService
    
    
    // constructor
    // ------------------------------------------
    init(testMode: Bool = false) {
        let db = DatabaseService(testMode: testMode)
        self.db = db
        self.auth = AuthenticationService(db: db)
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        ZStack {
            if (self.auth.loggedInUser == nil) {
                LoginView()
                
            } else {
                ZStack(alignment: .bottomTrailing) {
                    MyTabView()
                    MyFab(mode: .Add)
                        .padding(.trailing, mySpacing)
                        .padding(.bottom, 70)
                }
            }
            SplashScreen()
        }
        .environmentObject(self.auth)
        .environmentObject(self.db)

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(testMode: true)
    }
}
