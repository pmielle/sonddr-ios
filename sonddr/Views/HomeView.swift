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
    let accentColor: Color
    let goals: [Goal] = [
        Goal(id: "no_poverty", name: "No poverty", icon: "house.fill", color: Color("PinkGoalColor")),
        Goal(id: "health_and_well_being", name: "Health and well-being", icon: "cross.fill", color: Color("RedGoalColor")),
        Goal(id: "reduced_inequalitied", name: "Reduced inequalities", icon: "figure.2.arms.open", color: Color("OrangeGoalColor")),
        Goal(id: "sustainability", name: "Sustainability", icon: "infinity", color: Color("YellowGoalColor")),
        Goal(id: "preserved_ecosystems", name: "Preserved ecosystems", icon: "leaf.fill", color: Color("GreenGoalColor")),
        Goal(id: "peace_and_justice", name: "Peace and justice", icon: "bird.fill", color: Color("CyanGoalColor")),
        Goal(id: "decent_work", name: "Decent work", icon: "briefcase.fill", color: Color("BlueGoalColor")),
        Goal(id: "quality_education", name: "Quality education", icon: "graduationcap.fill", color: Color("PurpleGoalColor")),
    ]
    @State private var ideas: [Idea] = []
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    @State var topBackgroundHeight: CGFloat = 0
    let loggedInUser = dummyUser()
    let title = "All ideas"
    let topViewId = "topViewId"
    
    
    // constructor
    // ------------------------------------------
    init(accentColor: Color) {
        self.accentColor = accentColor
        self.changeNavbarStyle(color: accentColor)
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationView {
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
                                ideas: self.ideas,
                                pinnedHeaderColor: self.accentColor
                            )
                            Spacer()
                        }
                        .padding(.bottom, 100)
                        .onReceive(NotificationCenter.default.publisher(for: .ideasBottomBarIconTap)) { _ in
                            withAnimation {
                                reader.scrollTo(self.topViewId)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "idea-list-container")  // needed in IdeaList to style the pinned headers
                .refreshable {
                    self.getIdeas()
                }
                .onAppear {
                    self.getIdeas()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                self.toolbar()
            }
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
                ForEach(self.goals) { goal in
                    NavigationLink(destination: GoalView()) {
                        GoalChip(goal: goal)
                    }.buttonStyle(.plain)
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
            ProfilePicture(user: self.loggedInUser)
        }
    }
    
    
    // methods
    // ------------------------------------------
    func getIdeas() {
        self.ideas = [dummyIdea(), dummyIdea()]
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
        withAnimation {
            self.showNavigationBarTitle = offset.y > 50
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(accentColor: .red)
    }
}
