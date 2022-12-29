//
//  DiscussionView.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct DiscussionView: View {

    // attributes
    // ------------------------------------------
    // parameters
    let discussion: Discussion
    // environment
    @EnvironmentObject var fab: FabService
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("DiscussionView works!")
            
        }
        .stackFabMode(fab: self.fab, mode: .Send)
        .onFabTap(notificationName: .sendFabTap) {
            print("send message...")
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return NavigationView {
            DiscussionView(discussion: dummyDiscussion())
        }
        .environmentObject(fab)
    }
}
