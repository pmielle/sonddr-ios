//
//  ViewExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 29/11/2022.
//

import SwiftUI


// size of child
extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

// fab
struct StackFabMode: ViewModifier {
    @Environment(\.isPresented) private var isPresented
    @State var fab: FabService
    let mode: FabMode?
    @State var stackIndex: Int? = nil
    func body(content: Content) -> some View {
        let tab = self.fab.selectedTab
        return content
            .onChange(of: self.isPresented) { isPresented in
                if isPresented == false {
                    if self.stackIndex == self.fab.modeStack[tab!]!.count {
                        // back navigation
                        self.fab.modeStack[tab!]!.removeLast()
                    }
                }
            }
            .onAppear {
                if (self.stackIndex == nil) {
                    // first presentation
                    self.fab.modeStack[tab!]!.append(self.mode)
                    self.stackIndex = self.fab.modeStack[tab!]!.count
                }
            }
    }
}

extension View {
    func stackFabMode(fab: FabService, mode: FabMode?) -> some View {
        modifier(StackFabMode(fab: fab, mode: mode))
    }
}

