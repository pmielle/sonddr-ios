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
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func syncWithMode(mode: FabMode?) {
        Task {
            withAnimation(.easeOut(duration: myDurationInSec)) {
                self.offset = self.chooseOffset(mode: mode)
            }
            // only update if not hidden
            if mode != nil {
                self.color = self.chooseColor(mode: mode)
                self.icon = self.chooseIcon(mode: mode)
            }
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
        NavigationView {
            ZStack { MyBackground()
                MyFab(mode: .constant(.Add()))
            }
        }
    }
}
