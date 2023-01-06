//
//  MessagesView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct MessagesView: View {
    
    // attributes
    // ------------------------------------------
    // parameters
    @Binding var newDiscussionsNb: Int?
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject private var db: DatabaseService
    @EnvironmentObject private var auth: AuthenticationService
    @EnvironmentObject private var fab: FabService
    // constants
    let topViewId = randomId()
    let title = "Messages"
    // state
    @State private var discussions: [Discussion]? = nil {
        didSet {
            self.newDiscussionsNb = self.discussions != nil ? self.discussions!.count : nil
        }
    }
    @State private var isLoading = true
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var navigation = NavigationPath()
    @State var inProfile = false
    @State var inNewDiscussion = false
    @State var preselectedUser: User? = nil
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack(path: self.$navigation) {
                ZStack() { MyBackground()
                    ScrollViewWithOffset(
                        axes: .vertical,
                        showsIndicators: false,
                        offsetChanged: self.onScroll
                    ) {
                        ScrollViewReader { reader in
                            
                            VStack(alignment: .leading, spacing: mySpacing) {
                                self.titleView()
                                self.counter()
                                VStack(spacing: mySpacing) {
                                    if self.isLoading {
                                        self.discussionItem(discussion: dummyDiscussion())
                                            .redacted(reason: .placeholder)
                                        self.discussionItem(discussion: dummyDiscussion())
                                            .redacted(reason: .placeholder)
                                        
                                    } else {
                                        ForEach(self.discussions!) { discussion in
                                            NavigationLink(value: discussion) {
                                                self.discussionItem(discussion: discussion)
                                            }
                                        }
                                    }
                                }
                                .allowsHitTesting(!self.isLoading)
                                .onReceive(NotificationCenter.default.publisher(for: .messagesBottomBarIconTap)) { _ in
                                    self.onBottomBarIconTap(proxy: reader)
                                }
                                .padding(.vertical, mySpacing)
                            }
                            
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(myBackgroundColor, for: .navigationBar)
                .toolbar {
                    self.toolbar()
                }
                .navigationDestination(for: Discussion.self) { discussion in
                    DiscussionView(discussion: discussion)
                }
                .onFirstAppear {
                    self.initialLoad()
                }
                .onFabTap(notificationName: .newDiscussionFabTap) {
                    self.inNewDiscussion = true
                }
                .fullScreenCover(isPresented: self.$inNewDiscussion) {
                    NewDiscussionView(isPresented: self.$inNewDiscussion, preselectedUser: self.preselectedUser) { newDiscussion in
                        self.postDiscussion(newDiscussion: newDiscussion)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .goToDiscussion)) { notif in
                    self.goBackToNavigationRoot()
                    self.goToDiscussionWith(user: notif.userInfo!["user"] as! User)
                }
            }
    }
    
    
    // subviews
    // ------------------------------------------
    func discussionItem(discussion: Discussion) -> some View {
        let latestMessage = discussion.messages[0]
        let recipients = discussion.with.map { user in
            user.name
        }.joined(separator: ", ")
        return HStack(alignment: .top, spacing: mySpacing) {
            self.roundedPicture(path: discussion.picture)
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 0) {
                    Text(recipients)
                        .fontWeight(.bold)
                    Text(" · \(prettyTimeDelta(date:latestMessage.date))")
                        .opacity(0.5)
                }
                Text("\(latestMessage.from.name): \(latestMessage.body)")
                    .multilineTextAlignment(.leading)
                    .opacity(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .myGutter()
    }
        
    func counter() -> some View {
        HStack(spacing: mySpacing) {
            Text("\(self.discussions?.count ?? 1) unread")
            Circle().fill(.red).frame(height: 9)
        }
        .redacted(reason: self.isLoading ? .placeholder : [])
        .myGutter()
    }
    func titleView() -> some View {
        Text(self.title)
            .myTitle()
            .scaleEffect(self.titleScale, anchor: .bottomLeading)
            .myGutter()
            .padding(.top, mySpacing)
            .id(self.topViewId)
    }
    
    func roundedPicture(path: String) -> some View {
        let size = profilePictureSize
        return Rectangle()
            .frame(width: size, height: size)
            .overlay {
                Image(path)
                    .resizable()
            }
            .cornerRadius(99)
    }
    
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
    func postDiscussion(newDiscussion: Discussion) {
        Task {
            // post it to the database
            try? await self.db.postDiscussion(
                discussion: newDiscussion
            )
        }
        // add it to the local list of discussions
        self.discussions!.insert(newDiscussion, at: 0)
        // dismiss the new discussion sheet
        self.inNewDiscussion = false
        // go to this new discussion
        self.navigation.append(newDiscussion)
    }
    
    func goToDiscussionWith(user: User) {
        // if the discussion already exists, open it
        let matchingDiscussion = self.findDiscussionWith(user: user)
        if matchingDiscussion != nil {
            self.navigation.append(matchingDiscussion!)
            return
        }
        // else, create a new conversation and preselect this user
        self.preselectedUser = user
        self.inNewDiscussion = true
        Task {
            await sleep(seconds: myDurationInSec)
            self.preselectedUser = nil
        }
    }
    
    func findDiscussionWith(user: User) -> Discussion? {
        for discussion in self.discussions! {
            if discussion.with == [user] {
                return discussion
            }
        }
        return nil
    }
    
    func onBottomBarIconTap(proxy: ScrollViewProxy) {
        if (self.navigation.count > 0) {
            self.goBackToNavigationRoot()
        } else {
            withAnimation(.easeIn(duration: myDurationInSec)) {
                proxy.scrollTo(self.topViewId)
            }
        }
    }
    
    func goBackToNavigationRoot() {
        // FIXME: emptying the whole stack is not animated if count > 1
        // FIXME: tap mid-navigation breaks things
        self.navigation.removeLast(self.navigation.count)
        self.fab.modeStack[.Messages]!.removeLast(self.fab.modeStack[.Messages]!.count - 1)
    }
    
    func onScroll(offset: CGPoint) {
        // title scale
        if offset.y < -1 {
            self.titleScale = 1 - 0.001 * offset.y
        } else if self.titleScale > 1 {
            self.titleScale = 1.0
        }
        // navigation bar title
        withAnimation(.easeIn(duration: myShortDurationInSec)) {
            self.showNavigationBarTitle = offset.y > 50
        }
    }
    
    func initialLoad() {
        Task {
            await self.getDiscussions()
            if !self.forceLoadingState {
                self.isLoading = false
            }
        }
    }
    
    func getDiscussions() async {
        do {
            self.discussions = try await self.db.getDiscussions(user: self.auth.loggedInUser!)
        } catch {
            print("an error occured: \(error)")
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NavigationStack {
            MessagesView(newDiscussionsNb: .constant(nil))
                .environmentObject(auth)
                .environmentObject(db)
        }
        
        // 2nd preview with loading state
        // ------------------------------
        NavigationStack {
            MessagesView(newDiscussionsNb: .constant(nil), forceLoadingState: true)
                .environmentObject(auth)
                .environmentObject(db)
        }
    }
}
