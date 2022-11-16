//
//  MessagesView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct MessagesView: View {

    // attributes
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("MessagesView works!")
            
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MessagesView()
        }
    }
}
