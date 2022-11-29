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
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("IdeaView works!")
            
        }
        .onAppear {
            print("APPEAR")
        }
        .onDisappear {
            print("DISAPPEAR")
        }
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
        NavigationView {
            IdeaView()
        }
    }
}
