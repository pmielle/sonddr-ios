//
//  Notification.swift
//  sonddr
//
//  Created by Paul Mielle on 27/11/2022.
//

import SwiftUI

struct MyNotification: Identifiable {
    let id: String
    let content: String
    let date: Date
    let picture: String
}

func dummyNotification() -> MyNotification {
    MyNotification(
        id: randomId(),
        content: "Dummy notification content",
        date: Date.now - 300,
        picture: "DefaultProfilePicture")
}
