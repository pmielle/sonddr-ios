//
//  ProfileView.swift
//  sonddr
//
//  Created by Paul Mielle on 30/11/2022.
//

import SwiftUI

struct ProfileView: View {

    // attributes
    // ------------------------------------------
    @Binding var isPresented: Bool
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            ZStack() { MyBackground()
                
                Text("ProfileView works!")
                
            }
            .toolbar {
                self.toolbar()
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "xmark")
                .onTapGesture {
                    self.isPresented = false
                }
        }
    }
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isPresented: .constant(true))
        }
    }
}
