//
//  FabService.swift
//  sonddr
//
//  Created by Paul Mielle on 29/11/2022.
//

import SwiftUI

struct FabModeSubStack: Equatable {
    let mainMode: FabMode?
    var overrideMode: OverrideMode? = nil
}

struct OverrideMode: Equatable {
    let fabMode: FabMode?
}

@MainActor
class FabService: ObservableObject {
    @Published var selectedTab: Tab? = nil
    @Published var modeStack: [Tab: [FabModeSubStack]] = [
        .Ideas: [FabModeSubStack(mainMode: .Add)],
        .Search: [FabModeSubStack(mainMode: nil)],
        .Messages: [FabModeSubStack(mainMode: .NewDiscussion)],
        .Notifications: [FabModeSubStack(mainMode: nil)],
    ]
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}
