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
    let loggedInUser = dummyUser()
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack { MyBackground()
            ScrollViewWithOffset(axes: .vertical, showsIndicators: true, offsetChanged: self.onScroll) {
                VStack(spacing: 30) {
                    header()
                    IdeaList(ideas: self.ideas, showSortBy: self.showSortBy)
                    Spacer()
                }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image("Logo")
                    .resizable()
                    .frame(height: largeIconSize)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ProfilePicture(user: self.loggedInUser)
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func header() -> some View {
        VStack(alignment: .leading, spacing: mySpacing) {
            Text("All ideas")
                .myTitle()
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
    
    
    // methods
    // ------------------------------------------
    func onScroll(offset: CGPoint) {
        withAnimation { 
            self.showSortBy = offset.y <= 200
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
