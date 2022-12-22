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
    @Published var modeStack: [Tab: [[FabMode?]]] = [
        .Ideas: [[.Add]],
        .Search: [[nil]],
        .Messages: [[nil]],
        .Notifications: [[nil]],
    ] {
        didSet {
            print(self.modeStack[.Ideas])
        }
    }
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}
