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
        Goal(id: "no_poverty", name: "No poverty", icon: "house", color: .red),
        Goal(id: "quality_education", name: "Quality education", icon: "graduationcap", color: .green),
        Goal(id: "dff", name: "Quality education", icon: "graduationcap", color: .green),
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
                    IdeaList(ideas: self.ideas, showSortBy: self.showSortBy)
                    Spacer()
                }
            }
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
                    GoalChip(goal: goal)
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
