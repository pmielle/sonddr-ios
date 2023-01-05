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
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    @State var inProfile = false
    @State var scrollOffset: CGFloat = 0
    @State var inAdd = false
    
    
    // constructor
    // ------------------------------------------
    // ...


    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .top) { MyBackground()
            GeometryReader { geom in
                self.topBackground(topInset: geom.safeAreaInsets.top)
                    .zIndex(self.scrollOffset < 0 ? 1 : 2)
                
                // actual content starts here
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: false,
                    offsetChanged: self.onScroll
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
                .zIndex(self.scrollOffset < 0 ? 2 : 1)
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            self.toolbar()
        }
        .onFirstAppear {
            self.initialLoad()
        }
        .stackFabMode(fab: self.fab, mode: .Add)
        .onFabTap(notificationName: .addFabTap) {
            self.inAdd = true
        }
        .fullScreenCover(isPresented: self.$inAdd) {
            AddView(isPresented: self.$inAdd, preselectedGoal: self.goal) { newIdea in
                self.postIdea(newIdea: newIdea)
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func topBackground(topInset: CGFloat) -> some View {
        VStack(spacing: 0) {
            self.goal.color
                .frame(height: topInset + -1 * (self.scrollOffset < 0 ? self.scrollOffset : 0))
                .overlay(alignment: .bottom) {
                    if self.scrollOffset > 0 {
                        Color.gray
                            .opacity(0.5)
                            .frame(height: 0.5)
                    }
                }
        }
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
    func postIdea(newIdea: Idea) {
        Task {
            // post it to the database
            try? await self.db.postIdea(idea: newIdea)
        }
        // add it to the local list of ideas
        self.ideas!.insert(newIdea, at: 0)
        // TODO: open the idea directly
    }
    
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
    
    func onScroll(offset: CGPoint) {
        // sticky top background
        self.scrollOffset = offset.y
        // title scale
        self.titleScale = offset.y < 0 ? 1 - 0.001 * offset.y : 1.0
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
