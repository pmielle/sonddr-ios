//
//  UserView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct UserView: View {

    // attributes
    // ------------------------------------------
    @EnvironmentObject var fab: FabService
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("UserView works!")
            
        }
        .stackFabMode(fab: self.fab, mode: nil)
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return NavigationStack {
            UserView()
        }
        .environmentObject(fab)
    }
}
