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
    @State var mode: FabMode? = nil
    @State var isHidden = true
    @State var color: Color = MyFab.undefColor
    @State var icon: String = MyFab.undefIcon
    @State var secondaryIcon: String? = nil
    @State var showRatingFab = false
    static let undefColor: Color = .gray
    static let undefIcon: String = "questionmark"    
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack {
            if self.showRatingFab {
                RatingFab(rating: 75)
            } else {
                NormalFab(
                    color: self.$color,
                    icon: self.$icon,
                    secondaryIcon: self.$secondaryIcon)
                .onTapGesture {
                    self.onNormalFabTap()
                }
            }
        }
        .offset(x: self.isHidden ? self.offsetToHide : 0)
        .onAppear(perform: self.onModeInit)
        .onChange(of: self.fab.modeStack) { [oldModeStack = fab.modeStack] newModeStack in
            self.onModeChange(
                oldMode: oldModeStack[self.tab]!.last!.last!,
                newMode: newModeStack[self.tab]!.last!.last!)
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func onNormalFabTap() {
        switch self.mode {
        case .Add:
            NotificationCenter.default.post(Notification(name: .addFabTap))
        default:
            print("no action defined for mode \(String(describing: self.mode))")
            break
        }
    }
    
    func onModeInit() {
        self.mode = fab.modeStack[self.tab]!.last!.last!
        self.chooseUI(newMode: self.mode)
        if self.mode != nil {
            self.show()
        }
    }
    
    func onModeChange(oldMode: FabMode?, newMode: FabMode?) {
        let toOrFromRating = oldMode != .Rate && newMode == .Rate || oldMode == .Rate && newMode != .Rate
        let fromNil = oldMode == nil && newMode != nil
        let toNil = oldMode != nil && newMode == nil
        // choose a transition depending on the situation
        if fromNil {
            self.chooseUI(newMode: newMode)
            self.show()
        } else if toNil {
            Task {
                self.hide()
                await sleep(seconds: fabOffsetAnimationDuration)
                self.chooseUI(newMode: newMode)
            }
        } else if toOrFromRating {
            Task {
                self.hide()
                await sleep(seconds: fabOffsetAnimationDuration)
                self.chooseUI(newMode: newMode)
                self.show()
            }
        } else {
            self.chooseUI(newMode: newMode)
        }
        // n.b. else do nothing
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
    
    func chooseUI(newMode: FabMode?) {
        switch newMode {
        case .Add:
            self.color = myPrimaryColor
            self.icon = "lightbulb"
            self.secondaryIcon = "plus"
            self.showRatingFab = false
        case .Rate:
            self.color = MyFab.undefColor
            self.icon = MyFab.undefIcon
            self.secondaryIcon = nil
            self.showRatingFab = true
        case nil:
            self.color = MyFab.undefColor
            self.icon = MyFab.undefIcon
            self.secondaryIcon = nil
            self.showRatingFab = false
        }
    }
}

struct MyFab_Previews: PreviewProvider {
    static var previews: some View {
        let fab = FabService()
        return NavigationStack {
            ZStack { MyBackground()
                MyFab(tab: .Ideas)
            }
        }.environmentObject(fab)
    }
}
