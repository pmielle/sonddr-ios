//
//  Discussion.swift
//  sonddr
//
//  Created by Paul Mielle on 27/11/2022.
//

import SwiftUI

struct Discussion: Identifiable {
    let id: String
    let with: [User]
}

func dummyDiscussion() -> Discussion {
    Discussion(id: randomId(), with: [dummyUser()])
}
