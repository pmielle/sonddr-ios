//
//  FabService.swift
//  sonddr
//
//  Created by Paul Mielle on 29/11/2022.
//

import SwiftUI

@MainActor
class FabService: ObservableObject {
    @Published var mode: FabMode?
    var selectedTab: Tab? {
        didSet {
            self.refreshMode()
        }
    }
    var modeStack: [Tab: [FabMode?]] = [
        .Ideas: [.Add()],
        .Search: [nil],
        .Messages: [nil],
        .Notifications: [nil],
    ] {
        didSet {
            self.refreshMode()
        }
    }
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func refreshMode() {
        // disable fab if selectedTab is nil
        if self.selectedTab == nil {
            self.mode = nil
            return
        }
        // otherwise choose the last elem of the mode stack of this tab
        let activeStack = self.modeStack[self.selectedTab!]!
        self.mode = activeStack.count > 0 ? activeStack.last! : nil
    }
}
