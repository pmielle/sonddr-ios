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
        VStack(alignment: .leading, spacing: 0) {
            // title
            NavigationLink(destination: IdeaView()) {
                Text(self.idea.title)
                    .font(.headline)
            }.buttonStyle(.plain)
                .padding(.leading, profilePictureSize + self.profilePictureSpacing)
            // stuff below
            HStack(spacing: self.profilePictureSpacing) {
                NavigationLink(destination: UserView()) {
                    ProfilePicture(user: self.idea.author)
                }
                HStack(spacing: 0) {
                    NavigationLink(destination: UserView()) {
                        Text(self.idea.author.name)
                            .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                    Text(" · \(prettyTimeDelta(date:self.idea.date))")
                        .font(.subheadline)
                }
                .opacity(0.5)
            }
        }
        
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
