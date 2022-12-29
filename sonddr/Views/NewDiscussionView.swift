//
//  NewDiscussionView.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct NewDiscussionView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    // environment
    // ...
    // constants
    // ...
    // state
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            GeometryReader {reader in
                ZStack(alignment: .bottomTrailing) { MyBackground()
                    
                    // main content
                    ScrollView {
                        VStack {
                            
                            Text("NewDiscussionView works!")
                                .frame(maxWidth: .infinity)
                            
                        }
                        .padding(.bottom, 100)
                    }
                    
                    // fab
                    StandaloneFab(icon: "paperplane", color: .blue) {
                        print("start discussion...")
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                    .padding(.trailing, mySpacing)
                
                }
                .toolbar {
                    self.toolbar()
                }
                .navigationTitle("New discussion")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(myBackgroundColor, for: .navigationBar)
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
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
}

struct NewDiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        NewDiscussionView(isPresented: .constant(true))
    }
}
