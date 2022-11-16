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
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("GoalView works!")
            
        }
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
        NavigationView {
            GoalView()
        }
    }
}
