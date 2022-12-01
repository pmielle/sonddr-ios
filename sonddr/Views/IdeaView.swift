//
//  IdeaView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct IdeaView: View {

    // attributes
    // ------------------------------------------
    @EnvironmentObject var fab: FabService
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("IdeaView works!")
            
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

struct IdeaView_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return NavigationStack {
            IdeaView()
        }
        .environmentObject(fab)
    }
}
