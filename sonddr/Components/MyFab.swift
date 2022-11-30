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
    @Binding var mode: FabMode?
    @State var offset: CGFloat = mySpacing + 60  // FIXME: needs a custom init to get self.width
    @State var color: Color = .gray
    @State var icon: String = "questionmark"
    let width: CGFloat = 60
    let offsetAnimationDuration = 3
    @State var inAdd: Bool = false
    @State var preselectedGoal: Goal? = nil
    
    
    // body
    // ------------------------------------------
    var body: some View {
        Rectangle()
            .fill(self.color)
            .cornerRadius(99)
            .frame(width: self.width, height: self.width)
            .overlay {
                Image(systemName: self.icon)
            }
            .offset(x: self.offset)
            .onAppear { self.syncWithMode(mode: self.mode) }
            .onChange(of: self.mode, perform: self.syncWithMode)
            .fullScreenCover(isPresented: self.$inAdd) {
                AddView(isPresented: self.$inAdd, preselectedGoal: self.preselectedGoal)
            }
            .onTapGesture {
                self.onTap()
            }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func onTap() {
        switch mode {
        case let .Add(goal):
            self.preselectedGoal = goal
            self.inAdd = true
        default:
            break
        }
    }
    
    func syncWithMode(mode: FabMode?) {
        // hide or show if needed
        withAnimation(.easeOut(duration: myDurationInSec)) {
            self.offset = self.chooseOffset(mode: mode)
        }
        // udpate ui if visible
        if mode != nil {
            self.color = self.chooseColor(mode: mode)
            self.icon = self.chooseIcon(mode: mode)
        }
    }
    
    func chooseColor(mode: FabMode?) -> Color {
        switch mode {
        case .Add:
            return myPrimaryColor
        case nil:
            return .gray
        }
    }
    
    func chooseIcon(mode: FabMode?) -> String {
        switch mode {
        case .Add:
            return "plus"
        case nil:
            return "questionmark"
        }
    }
    
    func chooseOffset(mode: FabMode?) -> CGFloat {
        mode == nil ? self.width + mySpacing : 0
    }
}

struct MyFab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZStack { MyBackground()
                MyFab(mode: .constant(.Add()))
            }
        }
    }
}
