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
    @State var stackIndex: Int? = nil
    @State var pendingBackNavigation: FabMode? = nil
    func body(content: Content) -> some View {
        let tab = self.fab.selectedTab
        return content
            .onChange(of: self.isPresented) { isPresented in
                if isPresented {
                    if self.pendingBackNavigation != nil {
                        // back navigation has been cancelled (e.g. half swipe back)
                        // ...
                    }
                } else {
                    // back navigation starts
                    // ...
                }
            }
            .onDisappear {
                // back navigation ends
                // ...
            }
            .onAppear {
                // first presentation
                // ...
            }
    }
}

struct StackFabModeOverride: ViewModifier {
    @Environment(\.isPresented) private var isPresented
    @State var fab: FabService
    let mode: FabMode?
    func body(content: Content) -> some View {
        let tab = self.fab.selectedTab
        return content
            // ...
    }
}

extension View {
    func stackFabMode(fab: FabService, mode: FabMode?) -> some View {
        modifier(StackFabMode(fab: fab, mode: mode))
    }
    func stackFabModeOverride(fab: FabService, mode: FabMode?) -> some View {
        modifier(StackFabModeOverride(fab: fab, mode: mode))
    }
}



