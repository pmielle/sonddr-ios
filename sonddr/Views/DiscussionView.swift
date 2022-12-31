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
    @State var inProfile = false
    
    
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
                
                self.messages()
                self.input()
                
            }
            .padding(.bottom, bottomBarApproxHeight)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(myBackgroundColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
    func messages() -> some View {
        GeometryReader { reader in
            ScrollView {
                GeometryReader { geom in
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(self.discussion.messages.indices, id: \.self) { i in
                            let nextIsFromSameUser = self.chooseNextIsFromSameUser(i: i)
                            let message = self.discussion.messages[i]
                            MessageComponent(
                                message: message,
                                fromLoggedInUser: self.auth.loggedInUser == message.from,
                                nextIsFromSameUser: nextIsFromSameUser,
                                parentWidth: geom.size.width
                            )
                        }
                    }
                    .padding()
                    .frame(minHeight: reader.size.height)
                }
            }
        }
    }

    func chooseNextIsFromSameUser(i: Int) -> Bool {
        let message = self.discussion.messages[i]
        let user = message.from
        var nextIsFromSameUser = false
        if i < self.discussion.messages.count-1 {
            let nextMessage = self.discussion.messages[i+1]
            let nextUser = nextMessage.from
            if nextUser == user {
                nextIsFromSameUser = true
            }
        }
        return nextIsFromSameUser
    }
    
    func input() -> some View {
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
    
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(self.title)
                .myInlineToolbarTitle()
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
