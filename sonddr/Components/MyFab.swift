//
//  MyFab.swift
//  sonddr
//
//  Created by Paul Mielle on 17/11/2022.
//

import SwiftUI

enum Mode {
    case Add
    case Disabled
}

struct MyFab: View {

    // attributes
    // ------------------------------------------
    var mode: Mode
    @State var offset: CGFloat = 0
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
            .onAppear {
                Task {
                    await self.syncWithMode(mode: self.mode)
                }
            }
            .onChange(of: self.mode) { mode in
                Task {
                    await self.syncWithMode(mode: mode)
                }
            }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func syncWithMode(mode: Mode) async {
        // handle offset first: the rest is delayed if it changes
        let newOffset = self.chooseOffset(mode: mode)
        if (newOffset != self.offset) {
            withAnimation(.easeOut(duration: myDurationInSec)) {
                self.offset = newOffset
            }
            try? await Task.sleep(nanoseconds: myDurationInMs)
        }
        // rest of the updates
        self.color = self.chooseColor(mode: mode)
        self.icon = self.chooseIcon(mode: mode)

    }
    
    func chooseColor(mode: Mode) -> Color {
        switch mode {
        case .Add:
            return myPrimaryColor
        case .Disabled:
            return .gray
        }
    }
    
    func chooseIcon(mode: Mode) -> String {
        switch mode {
        case .Add:
            return "plus"
        case .Disabled:
            return "questionmark"
        }
    }
    
    func chooseOffset(mode: Mode) -> CGFloat {
        mode == .Disabled ? self.width + mySpacing : 0
    }
}

struct MyFab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                MyFab(mode: .Add)
            }
        }
    }
}
