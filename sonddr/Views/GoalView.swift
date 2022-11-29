//
//  GoalView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct GoalView: View {

    // attributes
    // ------------------------------------------
    @EnvironmentObject var fab: FabService
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("GoalView works!")
            
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

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        
        return NavigationView {
            GoalView()
        }
        .environmentObject(fab)
    }
}
