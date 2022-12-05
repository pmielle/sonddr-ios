//
//  GoalView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct GoalView: View {

    // attributes
    // ------------------------------------------
    // parameters
    let goal: Goal
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    @EnvironmentObject var fab: FabService
    // constant
    let topViewId = randomId()
    // state
    @State var ideas: [Idea]? = nil
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var topBackgroundHeight: CGFloat = 0
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    @State var inProfile = false
    
    
    // constructor
    // ------------------------------------------
    // ...


    // body
    // ------------------------------------------
    var body: some View {
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
                    VStack(spacing: 0) {
                        self.header()
                            .padding(.bottom, mySpacing)
                            .background(self.goal.color)
                            .id(self.topViewId)
                        IdeaList(
                            ideas: self.isLoading ? nil : self.ideas,
                            pinnedHeaderColor: self.goal.color,
                            sortBy: self.$sortBy
                        )
                        .allowsHitTesting(!self.isLoading)
                        Spacer()
                    }
                    .padding(.bottom, 100)
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
        .toolbarBackground(self.goal.color, for: .navigationBar)
        .toolbar {
            self.toolbar()
        }
        .onAppear {
            self.initialLoad()
        }
        .stackFabMode(fab: self.fab, mode: .Add(goal: dummyGoal()))
    }
    
    
    // subviews
    // ------------------------------------------
    func topBackground() -> some View {
        self.goal.color
            .frame(height: self.topBackgroundHeight)
            .ignoresSafeArea()
    }
    
    func header() -> some View {
        VStack(alignment: .leading, spacing: mySpacing) {
            Text(self.goal.name)
                .myTitle()
                .scaleEffect(self.titleScale, anchor: .bottomLeading)
                .myGutter()
                .padding(.top, mySpacing)
            Text("A description of this goal - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras auctor, eros vitae rhoncus cursus, urna justo hendrerit dolor, ut iaculis mi dolor eu enim. Donec ornare ex diam, id porta elit suscipit et.")
                .myGutter()
            HeaderHStack(shadowColor: self.goal.color) {
                Label("Learn more", systemImage: "info.circle")
                    .myLabel(color: .white)
                    .foregroundColor(self.goal.color)
                if self.isLoading {
                    GoalChip(goal: dummyGoal()).redacted(reason: .placeholder)
                    GoalChip(goal: dummyGoal()).redacted(reason: .placeholder)
                } else {
                    ForEach(self.db.goals!) { goal in
                        if goal != self.goal {
                            NavigationLink(value: goal) {
                                GoalChip(goal: goal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(self.goal.name)
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
            await self.getIdeas()
            if !self.forceLoadingState {
                self.isLoading = false
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

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
            NavigationStack {
                GoalView(goal: dummyGoal())
            }
            
            // 2nd preview with loading state
            // ------------------------------
            NavigationStack {
                GoalView(goal: dummyGoal(), forceLoadingState: true)
            }
        }
        .environmentObject(fab)
        .environmentObject(auth)
        .environmentObject(db)
    }
}
