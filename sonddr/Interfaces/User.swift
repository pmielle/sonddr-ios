//
//  User.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct User: Identifiable, Hashable {
    let id: String
    let name: String
    let profilePicture: String
    let externalLinks: [ExternalLink]
}

func dummyUser() -> User {
    User(
        id: randomId(),
        name: "Dummy User",
        profilePicture: "DefaultProfilePicture",
        externalLinks: [.Instagram]
    )
}
