//
//  NotificationsView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct NotificationsView: View {

    // attributes
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("NotificationsView works!")
            
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationsView()
        }
    }
}
