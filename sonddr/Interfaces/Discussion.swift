//
//  Discussion.swift
//  sonddr
//
//  Created by Paul Mielle on 27/11/2022.
//

import SwiftUI

struct Discussion: Identifiable, Hashable, Equatable {
    static func == (lhs: Discussion, rhs: Discussion) -> Bool {
        lhs.id == rhs.id
    }
    let id: String
    let with: [User]
    let picture: String
    let messages: [MyMessage]
}

func dummyDiscussion() -> Discussion {
    let with = dummyUser()
    return Discussion(
        id: randomId(),
        with: [with],
        picture: "DefaultProfilePicture",
        messages: [
            dummyMessage(from: with),
            dummyMessage(from: with)
        ])
}
