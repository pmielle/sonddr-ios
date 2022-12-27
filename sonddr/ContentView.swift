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
    @ObservedObject var fab: FabService = FabService()
    
    
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
                    ZStack(alignment: .bottom) {
                        MyFab(tab: .Ideas)
                            .opacity(self.fab.selectedTab == .Ideas ? 1 : 0)
                        MyFab(tab: .Search)
                            .opacity(self.fab.selectedTab == .Search ? 1 : 0)
                        MyFab(tab: .Messages)
                            .opacity(self.fab.selectedTab == .Messages ? 1 : 0)
                        MyFab(tab: .Notifications)
                            .opacity(self.fab.selectedTab == .Notifications ? 1 : 0)
                    }
                    .padding(.trailing, mySpacing)
                    .padding(.bottom, 70)
                }
            }
            SplashScreen()
        }
        .environmentObject(self.auth)
        .environmentObject(self.db)
        .environmentObject(self.fab)

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
