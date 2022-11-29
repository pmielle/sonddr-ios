//
//  ViewExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 29/11/2022.
//

import SwiftUI

struct StackFabMode: ViewModifier {
    @State var fab: FabService
    let mode: FabMode?
    func body(content: Content) -> some View {
        let tab = self.fab.selectedTab
        return content
            .onAppear {
                self.fab.modeStack[tab!]!.append(self.mode)
            }
            .onDisappear {
                self.fab.modeStack[tab!]!.removeLast()
            }
    }
}

extension View {
    func stackFabMode(fab: FabService, mode: FabMode?) -> some View {
        modifier(StackFabMode(fab: fab, mode: mode))
    }
}

