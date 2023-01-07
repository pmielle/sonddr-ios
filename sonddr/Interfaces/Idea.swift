//
//  Idea.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct Idea: Identifiable, Equatable, Hashable {
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
    let externalLinks: [ExternalLink]
    let content: String
}

func dummyIdea(old: Bool = false) -> Idea {
    Idea(
        id: randomId(),
        title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        author: dummyUser(),
        goals: [qualityEducation, healthAndWellBeing],
        cover: "DefaultIdeaCover",
        rating: 66,
        date: old ? Date.distantPast : Date.now - 300,
        externalLinks: [dummyExternalLink()],
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sem arcu, auctor et dolor ac, rutrum feugiat diam. Proin vel lorem ac velit tincidunt porta ac id libero. Donec laoreet pellentesque nisi vel semper. In consectetur iaculis elit eu vulputate. Nam fermentum, sapien eget varius consectetur, lacus nibh rhoncus erat, efficitur efficitur ipsum metus vitae erat. Cras tellus nunc, congue mattis malesuada vel, vestibulum in purus. Etiam ac consequat metus. Aenean non massa faucibus, bibendum ipsum vel, pulvinar erat. Integer finibus mi vel nulla dapibus convallis. In a pharetra neque. Phasellus quis commodo justo. Pellentesque risus dolor, mattis non ipsum posuere, pellentesque lacinia augue. Nam neque arcu, volutpat id facilisis molestie, vehicula ut purus."
    )
}
