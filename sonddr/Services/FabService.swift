//
//  FabService.swift
//  sonddr
//
//  Created by Paul Mielle on 29/11/2022.
//

import SwiftUI

@MainActor
class FabService: ObservableObject {
    @Published var selectedTab: Tab? = nil
    @Published var modeStack: [Tab: [FabMode?]] = [
        .Ideas: [.Add],
        .Search: [nil],
        .Messages: [nil],
        .Notifications: [nil],
    ]
    @Published var nbOverride: [Tab: Int] = [
        .Ideas: 0,
        .Search: 0,
        .Messages: 0,
        .Notifications: 0,
    ]
    @Published var pendingBackNavigation: [FabMode?] = []
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}
