//
//  Comment.swift
//  sonddr
//
//  Created by Paul Mielle on 20/12/2022.
//

import SwiftUI

struct Comment: Identifiable, Equatable {
    let id: String
    let from: User
    let body: String
    let score: Int
    let date: Date
}

func dummyComment() -> Comment {
    Comment(
        id: randomId(),
        from: dummyUser(),
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sem arcu, auctor et dolor ac, rutrum feugiat diam. Proin vel lorem ac velit tincidunt porta ac id libero. Donec laoreet pellentesque nisi vel semper. In consectetur iaculis elit eu vulputate. Nam fermentum, sapien eget varius consectetur, lacus nibh rhoncus erat, efficitur efficitur ipsum metus vitae erat.",
        score: 12,
        date: Date.now - 300)
}
