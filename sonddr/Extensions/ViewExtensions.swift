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


// offset in parent change
extension View {
    func offsetIn(space: CoordinateSpace, onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geom in
                Color.clear.preference(
                    key: ViewOffsetKey.self,
                    value: geom.frame(in: space).origin.y
                )
            }
        )
        .onPreferenceChange(ViewOffsetKey.self, perform: onChange)
    }
}


// react to fab tap
struct OnFabTap: ViewModifier {
    let notificationName: Notification.Name
    let perform: () -> Void
    @State var active = false
    func body(content: Content) -> some View {
        content
            .onAppear {
                self.active = true
            }
            .onDisappear {
                self.active = false
            }
            .onReceive(NotificationCenter.default.publisher(for: self.notificationName)) { _ in
                if !self.active { return }
                self.perform()
            }
    }
}

extension View {
    func onFabTap(notificationName: Notification.Name, perform: @escaping () -> Void) -> some View {
        modifier(OnFabTap(notificationName: notificationName, perform: perform))
    }
}


// fab mode
struct StackFabMode: ViewModifier {
    @Environment(\.isPresented) private var isPresented
    @State var fab: FabService
    let mode: FabMode?
    let isOverride: Bool
    @State var stackIndex: Int? = nil
    @State var pendingBackNavigation = false
    func body(content: Content) -> some View {
        let tab = self.fab.selectedTab
        return content
            .onChange(of: self.isPresented) { isPresented in
                if isPresented == false {
                    if self.fab.modeStack[tab!]!.count > 1 && self.stackIndex! >= self.fab.modeStack[tab!]!.count - self.fab.nbOverride[tab!]! {
                        // back navigation start...
                        self.pendingBackNavigation = true
                        self.fab.pendingBackNavigation.append(self.fab.modeStack[tab!]!.popLast()!)
                    }
                } else {
                    if self.pendingBackNavigation {
                        // back navigation has been cancelled (e.g. half swipe back)
                        self.pendingBackNavigation = false
                        if self.fab.pendingBackNavigation.count > 0 {
                            self.fab.modeStack[tab!]!.append(contentsOf: self.fab.pendingBackNavigation.reversed())
                            self.fab.pendingBackNavigation = []
                        }
                    }
                }
            }
            .onDisappear {
                // back navigation ends
                if self.fab.pendingBackNavigation.count > 0 {
                    self.fab.pendingBackNavigation = []
                    if self.isOverride {
                        self.fab.nbOverride[tab!]! -= 1
                    }
                } else {
                    // overide disappears without navigation
                    if self.isOverride && self.stackIndex! == self.fab.modeStack[tab!]!.count {
                        self.fab.modeStack[tab!]!.removeLast()
                        self.fab.nbOverride[tab!]! -= 1
                    }
                }
            }
            .onAppear {
                if (self.stackIndex == nil) {
                    // first presentation
                    self.fab.modeStack[tab!]!.append(self.mode)
                    self.stackIndex = self.fab.modeStack[tab!]!.count
                    if self.isOverride {
                        self.fab.nbOverride[tab!]! += 1
                    }
                }
            }
    }
}

extension View {
    func stackFabMode(fab: FabService, mode: FabMode?, isOverride: Bool = false) -> some View {
        modifier(StackFabMode(fab: fab, mode: mode, isOverride: isOverride))
    }
}



