//
//  HomeView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct HomeView: View {

    // attributes
    // ------------------------------------------
    // parameters
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    @EnvironmentObject var fab: FabService
    // constant
    let accentColor: Color = myBackgroundColor
    let title = "All ideas"
    let topViewId = randomId()
    // state
    @State var ideas: [Idea]? = nil
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var topBackgroundHeight: CGFloat = 0
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    @State var navigation = NavigationPath()
    @State var inProfile = false
    @State var inAdd = false
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack(path: self.$navigation) {
            ZStack(alignment: .top) { MyBackground()
                GeometryReader { geom in
                    self.topBackground()
                    
                    // actual content starts here
                    ScrollViewWithOffset(
                        axes: .vertical,
                        showsIndicators: true,
                        offsetChanged: { value in
                            self.onScroll(
                                offset: value,
                                height: geom.safeAreaInsets.top
                            )
                        }
                    ) {
                        ScrollViewReader { reader in
                            VStack(spacing: 0) {
                                header()
                                    .padding(.bottom, mySpacing)
                                    .background(self.accentColor)
                                    .id(self.topViewId)
                                IdeaList(
                                    ideas: self.isLoading ? nil : self.ideas,
                                    pinnedHeaderColor: self.accentColor,
                                    sortBy: self.$sortBy
                                )
                                .allowsHitTesting(!self.isLoading)
                                Spacer()
                            }
                            .padding(.bottom, 100)
                            .onReceive(NotificationCenter.default.publisher(for: .ideasBottomBarIconTap)) { _ in
                                self.onBottomBarIconTap(proxy: reader)
                            }
                        }
                    }
                    .scrollDisabled(self.isLoading)
                    .coordinateSpace(name: "idea-list-container")  // needed in IdeaList to style the pinned headers
                    .refreshable {
                        Task {
                            await self.getIdeas()
                        }
                    }
                    .onChange(of: self.sortBy) { _ in
                        Task {
                            await self.getIdeas()
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
                UserView()
            }
            .onAppear {
                self.initialLoad()
            }
            .onFabTap(notificationName: .addFabTap) {
                self.inAdd = true
            }
            .fullScreenCover(isPresented: self.$inAdd) {
                AddView(isPresented: self.$inAdd, preselectedGoal: nil)
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func topBackground() -> some View {
        self.accentColor
            .frame(height: self.topBackgroundHeight)
            .ignoresSafeArea()
    }
    
    func header() -> some View {
        VStack(alignment: .leading, spacing: mySpacing) {
            Text(self.title)
                .myTitle()
                .scaleEffect(self.titleScale, anchor: .bottomLeading)
                .myGutter()
                .padding(.top, mySpacing)
            Text("Every idea is linked to one or more goals it is trying to help with. You can filter them by using the chips below, or simply scroll down to see all of the latest ideas people have come up with.")
                .myGutter()
            HeaderHStack(shadowColor: self.accentColor) {
                Label("Learn more", systemImage: "info.circle")
                    .myLabel(color: .white)
                    .foregroundColor(self.accentColor)
                if self.isLoading {
                    GoalChip(goal: dummyGoal()).redacted(reason: .placeholder)
                    GoalChip(goal: dummyGoal()).redacted(reason: .placeholder)
                } else {
                    ForEach(self.db.goals!) { goal in
                        NavigationLink(value: goal) {
                            GoalChip(goal: goal)
                        }
                    }
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image("Logo")
                .resizable()
                .frame(height: largeIconSize)
        }
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
    func initialLoad() {
        Task {
            async let cacheGoals: () = try await self.db.cacheGoals()
            async let getIdeas: () = self.getIdeas()
            _ = try await [cacheGoals, getIdeas]
            if !self.forceLoadingState {
                self.isLoading = false
            }
        }
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
        self.fab.modeStack[.Ideas]!.removeLast(self.fab.modeStack[.Ideas]!.count - 1)
    }
    
    func getIdeas() async {
        do {
            self.ideas = try await self.db.getIdeas()
        } catch {
            print("an error occured: \(error)")
        }
    }
    
    func onScroll(offset: CGPoint, height: CGFloat) {
        // sticky top background
        if offset.y < 0 {
            self.topBackgroundHeight = -1 * offset.y + height // safety
        } else {
            if self.topBackgroundHeight > 0 {
                self.topBackgroundHeight = height
            }
        }
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
}

struct HomeView_Previews: PreviewProvider {    
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
            HomeView()
            HomeView(forceLoadingState: true)
                .previewDisplayName("Loading")
        }
        .environmentObject(auth)
        .environmentObject(db)
        .environmentObject(fab)
        
    }
}
