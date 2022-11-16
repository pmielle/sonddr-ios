//
//  SearchView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct SearchView: View {

    // attributes
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("SearchView works!")
            
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
