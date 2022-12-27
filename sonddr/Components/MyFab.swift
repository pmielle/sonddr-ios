//
//  MyFab.swift
//  sonddr
//
//  Created by Paul Mielle on 17/11/2022.
//

import SwiftUI

enum FabTransition {
    case Full
    case ShowOnly
    case HideOnly
    case None
}

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
        ZStack(alignment: .bottom) {
            // main fab
            self.fab(mode: self.mainMode)
                .opacity(self.overrideMode != nil ? 0 : 1)
            // override fab
            if self.overrideMode != nil {
                self.fab(mode: self.overrideMode!.fabMode)
            }
        }
        .offset(x: self.isHidden ? self.offsetToHide : 0)
        .onAppear {
            self.onInit()
        }
        .onChange(of: self.fab.modeStack) { [modeStack = fab.modeStack] newModeStack in
            if self.fab.selectedTab != self.tab { return }
            let oldModeStack = modeStack[self.tab]!
            let newModeStack = newModeStack[self.tab]!
            self.onModeStackChange(oldModeStack: oldModeStack, newModeStack: newModeStack)
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ViewBuilder
    func fab(mode: FabMode?) -> some View {
        switch mode {
        case .Add:
            NormalFab(color: myPrimaryColor, icon: "plus")
                .onTapGesture {
                    NotificationCenter.default.post(name: .addFabTap, object: nil)
                }
        case .Rate:
            RatingFab(rating: 66)
        case .Comment:
            NormalFab(color: Color("GreenColor"), icon: "paperplane")
                .onTapGesture {
                    NotificationCenter.default.post(name: .commentFabTap, object: nil)
                }
        case .NewDiscussion:
            NormalFab(color: Color("BlueColor"), icon: "plus")
                .onTapGesture {
                    NotificationCenter.default.post(name: .newDiscussionFabTap, object: nil)
                }
        case nil:
            NormalFab(color: .gray, icon: "questionmark")
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onInit() {
        self.mainMode = self.fab.modeStack[self.tab]!.last!.mainMode
        if self.mainMode != nil {
            self.isHidden = false
        }
    }
    
    func onModeStackChange(oldModeStack: [FabModeSubStack], newModeStack: [FabModeSubStack]) {
        let oldModeSubStack = oldModeStack.last!
        let newModeSubStack = newModeStack.last!
        let oldDisplayedMode = oldModeSubStack.overrideMode != nil ? oldModeSubStack.overrideMode!.fabMode : oldModeSubStack.mainMode
        let newDisplayedMode = newModeSubStack.overrideMode != nil ? newModeSubStack.overrideMode!.fabMode : newModeSubStack.mainMode
        // if the mode changes, hide fab during transition
        let transition = self.chooseTransition(oldMode: oldDisplayedMode, newMode: newDisplayedMode)
        Task {
            if transition == .Full || transition == .HideOnly {
                self.hide()
                await sleep(seconds: fabOffsetAnimationDuration)
            }
            self.mainMode = newModeSubStack.mainMode
            self.overrideMode = newModeSubStack.overrideMode
            if transition == .Full || transition == .ShowOnly {
                self.show()
            }
        }
    }
    
    func chooseTransition(oldMode: FabMode?, newMode: FabMode?) -> FabTransition {
        if oldMode == newMode {
            return .None
        }
        if oldMode == nil {
            return .ShowOnly
        }
        if newMode == nil {
            return .HideOnly
        }
        return .Full
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
