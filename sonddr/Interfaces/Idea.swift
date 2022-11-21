//
//  Idea.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct Idea: Identifiable, Equatable {
    static func == (lhs: Idea, rhs: Idea) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let title: String
    let author: User
    let goals: [Goal]
    let cover: String
    let rating: Int
    let date: Date
}

func dummyIdea() -> Idea {
    Idea(
        id: randomId(),
        title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        author: dummyUser(),
        goals: [dummyGoal(), dummyGoal()],
        cover: "DefaultIdeaCover",
        rating: 66,
        date: Date.now - 300
    )
}
