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
        NavigationLink(value: self.idea) {
            
            // cover
            Image(self.idea.cover)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    // goal and rating badges
                    HStack {
                        HStack {
                            ForEach(self.idea.goals) { goal in
                                NavigationLink(value: goal) {
                                    GoalBadge(goal: goal)
                                }
                            }
                        }
                        Spacer()
                        RatingBadge(rating: self.idea.rating)
                    }
                    .myGutter()
                    .padding(.bottom, 10)
                    .padding(.leading, self.profilePictureSpacing + profilePictureSize)
                }
            
        }
    }
    
    func bottomInfo() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // title
            NavigationLink(value: self.idea) {
                Text(self.idea.title)
                    .font(.headline)
            }
            .padding(.leading, profilePictureSize + self.profilePictureSpacing)
            // stuff below
            HStack(spacing: self.profilePictureSpacing) {
                NavigationLink(value: self.idea.author) {
                    ProfilePicture(user: self.idea.author)
                }
                HStack(spacing: 0) {
                    NavigationLink(value: self.idea.author) {
                        Text(self.idea.author.name)
                            .font(.subheadline)
                    }
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
        NavigationStack {
            ZStack { MyBackground()
                IdeaCard(idea: dummyIdea())
            }
        }
    }
}
