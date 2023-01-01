//
//  NotificationsView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct NotificationsView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var newNotificationsNb: Int?
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject private var db: DatabaseService
    @EnvironmentObject private var auth: AuthenticationService
    @EnvironmentObject private var fab: FabService
    // constant
    let topViewId = randomId()
    let title = "Notifications"
    // state
    @State private var notifications: [MyNotification]? = nil {
        didSet {
            self.newNotificationsNb = self.notifications != nil ? self.notifications!.count : nil
        }
    }
    @State private var isLoading = true
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var navigation = NavigationPath()
    @State var inProfile = false
    
    
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
                                    self.notificationItem(notification: dummyNotification())
                                        .redacted(reason: .placeholder)
                                    self.notificationItem(notification: dummyNotification())
                                        .redacted(reason: .placeholder)
                                    
                                } else {
                                    ForEach(self.notifications!) { notification in
                                        self.notificationItem(notification: notification)
                                    }
                                }
                            }
                            .allowsHitTesting(!self.isLoading)
                            .onReceive(NotificationCenter.default.publisher(for: .notificationsBottomBarIconTap)) { _ in
                                self.onBottomBarIconTap(proxy: reader)
                            }
                            .padding(.vertical, mySpacing)
                            self.loadOlder()
                        }
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(myBackgroundColor, for: .navigationBar)
            .toolbar {
                self.toolbar()
            }
            .navigationDestination(for: Idea.self) { idea in
                IdeaView(idea: idea)
            }
            .navigationDestination(for: Goal.self) { goal in
                GoalView(goal: goal)
            }
            .navigationDestination(for: User.self) { user in
                UserView(user: user)
            }
            .onAppear {
                self.initialLoad()
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func loadOlder() -> some View {
        Label("Load older notifications", systemImage: "chevron.down")
            .labelStyle(TrailingIcon())
            .myLabel(color: .clear, border: .white)
            .foregroundColor(.white)
            .myGutter()
    }
    
    func counter() -> some View {
        HStack(spacing: mySpacing) {
            Text("\(self.notifications?.count ?? 1) unread")
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
    
    func notificationItem(notification: MyNotification) -> some View {
        HStack(alignment: .top, spacing: mySpacing) {
            self.roundedPicture(path: notification.picture)
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.content)
                Text(prettyTimeDelta(date:notification.date))
                    .opacity(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .myGutter()
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
        self.fab.modeStack[.Notifications]!.removeLast(self.fab.modeStack[.Notifications]!.count - 1)
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
            await self.getNotifications()
            if !self.forceLoadingState {
                self.isLoading = false
            }
        }
    }
    
    func getNotifications() async {
        do {
            self.notifications = try await self.db.getNotifications(user: self.auth.loggedInUser!)
        } catch {
            print("an error occured: \(error)")
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
                NotificationsView(newNotificationsNb: .constant(nil))
                NotificationsView(newNotificationsNb: .constant(nil), forceLoadingState: true)
                .previewDisplayName("Loading")
            }
            .environmentObject(auth)
            .environmentObject(db)
            .environmentObject(fab)
    }
}
