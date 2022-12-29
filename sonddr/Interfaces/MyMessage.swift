//
//  MyMessage.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct MyMessage: Identifiable, Hashable {
    let id: String
    let from: User
    let body: String
    let date: Date
}

func dummyMessage(from: User) -> MyMessage {
    MyMessage(
        id: randomId(),
        from: from,
        body: "Dummy message content",
        date: Date.now - 300
    )
}

