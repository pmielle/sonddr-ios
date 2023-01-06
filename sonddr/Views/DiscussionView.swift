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
    @State var localMessages: [MyMessage]  // TODO: make this cleaner by de-coupling discussion and messages eventually
    @State var inputText = ""
    @State var inProfile = false
    
    
    // constructor
    // ------------------------------------------
    init(discussion: Discussion) {
        self.discussion = discussion
        self.title = discussion.with.map { $0.name }.joined(separator: ", ")
        self.localMessages = discussion.messages
    }
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            VStack(spacing: 0) {
                
                self.messagesView()
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
            self.onSubmit()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func messagesView() -> some View {
        GeometryReader { reader in
            ScrollView {
                GeometryReader { geom in
                    VStack(spacing: 0) {
                        Spacer()
                        
//                        ForEach(self.messages) { message in
//                            Text(message.body)
//                        }
//
                        ForEach(self.localMessages.indices, id: \.self) { i in
                            let nextIsFromSameUser = self.chooseNextIsFromSameUser(i: i)
                            let message = self.localMessages[i]
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
        let message = self.localMessages[i]
        let user = message.from
        var nextIsFromSameUser = false
        if i < self.localMessages.count-1 {
            let nextMessage = self.localMessages[i+1]
            let nextUser = nextMessage.from
            if nextUser == user {
                nextIsFromSameUser = true
            }
        }
        return nextIsFromSameUser
    }
    
    func input() -> some View {
        VStack(spacing: 0) {
            Divider()
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
            .padding(.vertical, mySpacing)
            .padding(.trailing, mySpacing + fabSize)
        }
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
    func onSubmit() {
        // validate the input
        let body = self.inputText
        if body.isEmpty {
            print("[error] please enter a message")
            return
        }
        let date = Date.now
        let from = self.auth.loggedInUser!
        // build the message
        let message = MyMessage(
            id: randomId(),
            from:from,
            body: body,
            date: date)
        // post it to the database
        Task {
            try? await self.db.postMessage(message: message, inDiscussion: self.discussion)
        }
        // add it to the local list of messages
        withAnimation(.easeOut(duration: myShortDurationInSec)) {
            self.localMessages.append(message)
        }
        // clear the input field
        self.inputText = ""
    }
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
