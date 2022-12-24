//
//  MyFab.swift
//  sonddr
//
//  Created by Paul Mielle on 17/11/2022.
//

import SwiftUI

struct MyFab: View {

    // attributes
    // ------------------------------------------
    // parameters
    let tab: Tab
    // environment
    @EnvironmentObject var fab: FabService
    // constant
    let offsetToHide = mySpacing + fabSize
    // state
    @State var isHidden = true
    @State var mainMode: FabMode? = nil
    @State var overrideMode: OverrideMode? = nil
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack {
            self.mainFab(mode: self.mainMode)
                .opacity(self.overrideMode != nil ? 0 : 1)
            if self.overrideMode != nil {
                self.overrideFab(mode: self.overrideMode!.fabMode)
            }
        }
        .offset(x: self.isHidden ? self.offsetToHide : 0)
        .onAppear {
            // ...
        }
        .onChange(of: self.fab.modeStack) { [modeStack = fab.modeStack] newModeStack in
            if self.fab.selectedTab != self.tab { return }
            let oldModeStack = modeStack[self.tab]!
            let newModeStack = newModeStack[self.tab]!
            let oldModeSubStack = oldModeStack.last!
            let newModeSubStack = newModeStack.last!
            if oldModeStack.count != newModeStack.count {
                self.onModeSubStackChange(oldModeSubStack: oldModeSubStack, newModeSubStack: newModeSubStack)
            } else {
                self.onOverrideModeChange(oldOverride: oldModeSubStack.overrideMode, newOverride: newModeSubStack.overrideMode)
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func mainFab(mode: FabMode?) -> some View {
        return Text("MAIN")
    }
    
    func overrideFab(mode: FabMode?) -> some View {
        Text("OVERRIDE")
    }
    
    
    // methods
    // ------------------------------------------
    func onModeSubStackChange(oldModeSubStack: FabModeSubStack, newModeSubStack: FabModeSubStack) {
        print("SUBSTACK CHANGE")
    }
    
    func onOverrideModeChange(oldOverride: OverrideMode?, newOverride: OverrideMode?) {
        print("OVERRIDE CHANGE")
    }
    
    func show() {
        withAnimation(.easeOut(duration: fabOffsetAnimationDuration)) {
            self.isHidden = false
        }
    }
    
    func hide() {
        withAnimation(.easeIn(duration: fabOffsetAnimationDuration)) {
            self.isHidden = true
        }
    }
    
}

struct MyFab_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        fab.selectedTab = .Ideas
        return NavigationStack {
            ZStack { MyBackground()
                MyFab(tab: .Ideas)
            }
        }.environmentObject(fab)
    }
}
