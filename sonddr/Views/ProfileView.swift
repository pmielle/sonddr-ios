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
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            ZStack() { MyBackground()
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: true,
                    offsetChanged: self.onScrollViewOffsetChange
                ) {
                    Text("ProfileView works!")
                }
                
            }
            .toolbar {
                self.toolbar()
            }
            .toolbarBackground(myBackgroundColor, for: .navigationBar)
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
    func onScrollViewOffsetChange(offset: CGPoint) {
        print("offset changed: \(offset.y)")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isPresented: .constant(true))
        }
    }
}
