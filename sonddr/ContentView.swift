//
//  ContentView.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    // attributes
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MyTabView()
            MyFab(mode: .Add)
                .padding(.trailing, mySpacing)
                .padding(.bottom, 70)
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
