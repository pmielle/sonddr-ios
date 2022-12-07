//
//  AddView.swift
//  sonddr
//
//  Created by Paul Mielle on 30/11/2022.
//

import SwiftUI

struct AddView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    let preselectedGoal: Goal?
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constant
    let accentColor: Color = myBackgroundColor
    let coverPlaceholderColor: Color = .gray
    // state
    @State var negativeOffset: CGFloat = 0
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            ZStack() { MyBackground()
                GeometryReader {reader in
                    
                    ScrollViewWithOffset(
                        axes: .vertical,
                        showsIndicators: true,
                        offsetChanged: self.onScroll
                    ) {
                        VStack(spacing: 0) {
                            self.header(topInset: reader.safeAreaInsets.top)
                                .padding(.bottom, mySpacing)
                            HStack(alignment: .top, spacing: mySpacing) {
                                ProfilePicture(user: self.auth.loggedInUser!)
                                Text("Explain your idea")
                                    .foregroundColor(self.coverPlaceholderColor)
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)  // so that very short bio alignment.leading
                            }
                            .myGutter()
                            Spacer()
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .toolbar {
                self.toolbar()
            }
            .navigationTitle("Share an idea")
            .navigationBarTitleDisplayMode(.inline)
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
    
    func cover(topInset: CGFloat) -> some View {
        GeometryReader { _ in
            Color.gray
                .frame(height: coverPictureHeight + self.negativeOffset)
        }
        .frame(height: coverPictureHeight - topInset)
        .offset(y: -1 * (topInset + self.negativeOffset))
    }
    
    func header(topInset: CGFloat) -> some View {
        ZStack (alignment: .top) {
            self.cover(topInset: topInset)
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: coverPictureHeight - topInset - 30 - mySpacing)  // 30 is the height of the goal chip
                VStack(alignment: .leading, spacing: 2 * mySpacing) {
                    HeaderHStack(shadowColor: self.coverPlaceholderColor, additionalLeftPadding: mySpacing + profilePictureSize) {
                        // ...
                        // TODO: foreach external link, display icon
                        // ...
                        Label("Goal(s) of interest", systemImage: "plus.circle")
                            .myLabel(color: myBackgroundColor)
                    }
                    Text("Choose a title")
                        .myTitle()
                        .myGutter()
                        .padding(.leading, mySpacing + profilePictureSize)
                }
                .foregroundColor(self.coverPlaceholderColor)
            }
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onScroll(offset: CGPoint) {
        // sticky top background
        self.negativeOffset = offset.y < 0 ? -1 * offset.y : 0
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        AddView(isPresented: .constant(true), preselectedGoal: nil)
            .environmentObject(auth)
            .environmentObject(db)
    }
}
