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
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    let accentColor: Color
    @State var ideas: [Idea]? = nil
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var topBackgroundHeight: CGFloat = 0
    let title = "All ideas"
    let topViewId = "topViewId"
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    let forceLoadingState: Bool
    @State var navigation = NavigationPath()
    @State var inProfile = false
    
    
    // constructor
    // ------------------------------------------
    init(accentColor: Color, forceLoadingState: Bool = false) {
        self.forceLoadingState = forceLoadingState
        self.accentColor = accentColor
        self.changeNavbarStyle(color: accentColor)
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack(path: self.$navigation) {
            ZStack(alignment: .top) { MyBackground()
                
                self.topBackground()
                ScrollViewWithOffset(axes: .vertical, showsIndicators: true, offsetChanged: self.onScroll) {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                self.toolbar()
            }
            .navigationDestination(for: Idea.self) { idea in
                IdeaView()
            }
            .navigationDestination(for: Goal.self) { goal in
                GoalView()
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
            self.navigation.removeLast(self.navigation.count)
        } else {
            withAnimation(.easeIn(duration: myDurationInSec)) {
                proxy.scrollTo(self.topViewId)
            }
        }
    }
    
    func getIdeas() async {
        do {
            self.ideas = try await self.db.getIdeas()
        } catch {
            print("an error occured: \(error)")
        }
    }
    
    func changeNavbarStyle(color: Color) {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(color)
        coloredNavAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().compactAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = coloredNavAppearance
    }
    
    func onScroll(offset: CGPoint) {
        // sticky top background
        if offset.y < 10 {  // 10px safety
            self.topBackgroundHeight = -1 * offset.y + 10  // 10px safety
        } else if self.topBackgroundHeight > 0 {
            self.topBackgroundHeight = 0
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
            HomeView(accentColor: .red)
                
            // 2nd preview with loading state
            // ------------------------------
            HomeView(accentColor: .red, forceLoadingState: true)
        }
        .environmentObject(auth)
        .environmentObject(db)
        .environmentObject(fab)
        
    }
}
