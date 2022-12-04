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
    let forceLoadingState: Bool
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
    @State var isTopBackgroundAbove = false
    
    
    // constructor
    // ------------------------------------------
    init(forceLoadingState: Bool = false) {
        setNavigationBarColor(color: .clear)
        self.forceLoadingState = forceLoadingState
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack(path: self.$navigation) {
            ZStack(alignment: .top) { MyBackground()
                GeometryReader { geom in
                    self.topBackground().zIndex(self.isTopBackgroundAbove ? 2 : 1)
                    
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
                    .zIndex(self.isTopBackgroundAbove ? 1 : 2)
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
            .toolbar {
                self.toolbar()
            }
            .navigationDestination(for: Idea.self) { idea in
                IdeaView()
            }
            .navigationDestination(for: Goal.self) { goal in
                GoalView(goal: goal)
            }
            .navigationDestination(for: User.self) { user in
                UserView()
            }
        }
        .onAppear {
            self.initialLoad()
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
                .font(.headline)
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
        self.navigation.removeLast(self.navigation.count)  // FIXME: emptying the whole stack *is not animated* when count > 1
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
            if self.isTopBackgroundAbove {
                self.isTopBackgroundAbove = false
            }
            self.topBackgroundHeight = -1 * offset.y + height // safety
        } else {
            if !self.isTopBackgroundAbove {
                self.isTopBackgroundAbove = true
            }
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
                
            // 2nd preview with loading state
            // ------------------------------
            HomeView(forceLoadingState: true)
        }
        .environmentObject(auth)
        .environmentObject(db)
        .environmentObject(fab)
        
    }
}
