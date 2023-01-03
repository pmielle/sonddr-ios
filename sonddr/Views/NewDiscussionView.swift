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
    var preselectedUser: User? = nil
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
                        VStack(spacing: 0) {
                            TextField("To:", text: self.$toInputText)
                                .myGutter()
                                .padding(.vertical, mySpacing)
                            Divider()
                        }
                        
                        // content
                        ScrollView {
                            VStack {
                                
                                // ...
                                
                            }
                        }
                        
                        // message input
                        VStack(spacing: 0) {
                            Divider()
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
                            .padding(.vertical, mySpacing)
                            .padding(.trailing, mySpacing + fabSize)
                        }
                    }
                    .padding(.bottom, bottomBarApproxHeight)
                    
                    // fab
                    StandaloneFab(icon: "paperplane", color: myBlueColor) {
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
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    if self.preselectedUser != nil {
                        self.toInputText = self.preselectedUser!.name
                    }
                }
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

struct NewDiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        NewDiscussionView(isPresented: .constant(true))
    }
}
