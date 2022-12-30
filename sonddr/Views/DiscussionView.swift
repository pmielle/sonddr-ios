//
//  DiscussionView.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct DiscussionView: View {

    // attributes
    // ------------------------------------------
    // parameters
    let discussion: Discussion
    // environment
    @EnvironmentObject var fab: FabService
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constants
    let title: String
    // state
    @State var inputText = ""
    @State var showNavigationBarTitle = false
    @State var inProfile = false
    @State var scrollViewOffset: CGFloat = 0
    
    
    // constructor
    // ------------------------------------------
    init(discussion: Discussion) {
        self.discussion = discussion
        self.title = discussion.with.map { $0.name }.joined(separator: ", ")
    }
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            VStack(spacing: 0) {
                
                // header
                // ...
                
                // messages
                ScrollViewWithOffset(axes: .vertical, showsIndicators: false) { offset in
                    self.scrollViewOffset = offset.y
                } content: {
                    VStack {
                        Text("DiscussionView works!")
                    }
                }
                
                // input
                HStack(spacing: mySpacing) {
                    Button {
                        print("attach...")
                    } label: {
                        Image(systemName: "paperclip")
                    }
                    TextField("Your message", text: self.$inputText)
                }
                .frame(height: fabSize)
                .myGutter()
                .padding(.bottom, mySpacing)
                .padding(.trailing, mySpacing + fabSize)
            }
            .padding(.bottom, bottomBarApproxHeight)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(myBackgroundColor, for: .navigationBar)
        .toolbarBackground(self.scrollViewOffset > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbar {
            self.toolbar()
        }
        .stackFabMode(fab: self.fab, mode: .Send)
        .onFabTap(notificationName: .sendFabTap) {
            print("send message...")
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(self.title)
                .myInlineToolbarTitle()
                .opacity(self.showNavigationBarTitle ? 1 : 0)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            ProfilePicture(user: self.auth.loggedInUser!)
                .onTapGesture {
                    self.inProfile = true
                }
                .fullScreenCover(isPresented: self.$inProfile) {
                    ProfileView(isPresented: self.$inProfile)
                }
        }
    }
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return NavigationView {
            DiscussionView(discussion: dummyDiscussion())
        }
        .environmentObject(fab)
        .environmentObject(db)
        .environmentObject(auth)
    }
}
