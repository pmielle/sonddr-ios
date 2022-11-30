//
//  Goal.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct Goal: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let icon: String  // SF symbol
    let color: Color
}

func dummyGoal() -> Goal {
    Goal(
        id: randomId(),
        name: "Dummy Goal",
        icon: "bolt.fill",
        color: .red
    )
}
