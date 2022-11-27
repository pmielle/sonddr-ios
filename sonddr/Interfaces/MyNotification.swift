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
}

func dummyNotification() -> MyNotification {
    MyNotification(id: randomId(), content: "Dummy notification content")
}
