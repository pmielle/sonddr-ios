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
    let ideas: [Idea] = [
        dummyIdea(),
        dummyIdea(),
        dummyIdea(),
        dummyIdea(),
    ]
    @State var showSortBy = true
    @State var titleScale = 1.0
    @State var showNavigationBarTitle = false
    let loggedInUser = dummyUser()
    let title = "All ideas"
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack { MyBackground()
            ScrollViewWithOffset(axes: .vertical, showsIndicators: true, offsetChanged: self.onScroll) {
                VStack(spacing: mySpacing) {
                    header()
                    IdeaList(
                        ideas: self.ideas,
                        showSortBy: self.showSortBy,
                        pinnedHeaderColor: .blue
                    )
                    Spacer()
                }
            }
            .coordinateSpace(name: "idea-list-container")  // needed in IdeaList to style the pinned headers
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            self.toolbar()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func header() -> some View {
        VStack(alignment: .leading, spacing: mySpacing) {
            Text(self.title)
                .myTitle()
                .scaleEffect(self.titleScale, anchor: .bottomLeading)
                .myGutter()
                .padding(.top, mySpacing)
            Text("Every idea is linked to one or more goals it is trying to help with. You can filter them by using the chips below, or simply scroll down to see all of the latest ideas people have come up with.")
                .myGutter()
            HeaderHStack {
                Label("Learn more", systemImage: "info.circle")
                    .myLabel(color: .white)
                    .foregroundColor(myBackgroundColor)
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
    func onScroll(offset: CGPoint) {
        // sort by icon
        withAnimation { 
            self.showSortBy = offset.y < 50
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
        NavigationView {
            HomeView()
        }
    }
}
