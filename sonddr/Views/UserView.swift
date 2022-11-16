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
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("UserView works!")
            
        }
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
        NavigationView {
            UserView()
        }
    }
}
