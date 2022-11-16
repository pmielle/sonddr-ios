//
//  IdeaCard.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct IdeaCard: View {
    
    // attributes
    // ------------------------------------------
    let idea: Idea
    let profilePictureSpacing: CGFloat = 10
    
    
    // body
    // ------------------------------------------
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            self.cover()
            self.bottomInfo()
                .myGutter()
                .padding(.vertical, 10)
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func cover() -> some View {
        NavigationLink(destination: IdeaView()) {
            // cover
            Image(self.idea.cover)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    // goal and rating badges
                    HStack {
                        HStack {
                            ForEach(self.idea.goals) { goal in
                                NavigationLink(destination: GoalView()) {
                                    GoalBadge(goal: goal)
                                }.buttonStyle(.plain)
                            }
                        }
                        Spacer()
                        RatingBadge(rating: self.idea.rating)
                    }
                    .myGutter()
                    .padding(.bottom, 10)
                    .padding(.leading, self.profilePictureSpacing + profilePictureSize)
                }
        }.buttonStyle(.plain)
    }
    
    func bottomInfo() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            // title
            NavigationLink(destination: IdeaView()) {
                Text(self.idea.title)
                    .font(.title2)
            }.buttonStyle(.plain)
            // stuff below
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    NavigationLink(destination: UserView()) {
                        Text(self.idea.author.name)
                    }
                    .buttonStyle(.plain)
                    Text(" · \(prettyTimeDelta(date:self.idea.date))")
                }
                .opacity(0.5)
                NavigationLink(destination: UserView()) {
                    ProfilePicture(user: self.idea.author)
                        .offset(x: -1 * (profilePictureSize + self.profilePictureSpacing))
                }
            }
        }
        .padding(.leading, profilePictureSize + self.profilePictureSpacing)
    }

    
    // methods
    // ------------------------------------------
    // ...
}

struct IdeaCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                IdeaCard(idea: dummyIdea())
            }
        }
    }
}
