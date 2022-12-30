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
    @State var toInputText = ""
    @State var bodyInputText = ""
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            GeometryReader {reader in
                ZStack(alignment: .bottomTrailing) { MyBackground()
                    
                    VStack {
                        // To:
                        TextField("To:", text: self.$toInputText)
                            .myGutter()
                            .padding(.top, mySpacing)
                        
                        // content
                        ScrollView {
                            VStack {
                                
                                // ...
                                
                            }
                        }
                        
                        // message input
                        HStack(spacing: mySpacing) {
                            Button {
                                print("attach...")
                            } label: {
                                Image(systemName: "paperclip")
                            }
                            TextField("Your message", text: self.$bodyInputText)
                        }
                        .frame(height: fabSize)
                        .myGutter()
                        .padding(.bottom, mySpacing)
                        .padding(.trailing, mySpacing + fabSize)

                    }
                    .padding(.bottom, bottomBarApproxHeight)
                    
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
