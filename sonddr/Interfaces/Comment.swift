//
//  Comment.swift
//  sonddr
//
//  Created by Paul Mielle on 20/12/2022.
//

import SwiftUI

struct Comment: Identifiable {
    let id: String
    let from: User
    let body: String
    let score: Int
}

func dummyComment() -> Comment {
    Comment(id: randomId(), from: dummyUser(), body: "Dummy comment content", score: 12)
}
