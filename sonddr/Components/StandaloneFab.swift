//
//  StandaloneFab.swift
//  sonddr
//
//  Created by Paul Mielle on 07/12/2022.
//

import SwiftUI

struct StandaloneFab: View {

    // attributes
    // ------------------------------------------
    let icon: String
    let color: Color
    let onTap: () -> ()
    @State var isHidden: Bool = true
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        NormalFab(color: self.color, icon: self.icon)
            .offset(x: self.isHidden ? mySpacing + fabSize : 0)
            .onTapGesture {
                self.onTap()
            }
            .onAppear {
                withAnimation(.easeOut(duration: fabOffsetAnimationDuration).delay(myDurationInSec)) {
                    self.isHidden = false
                }
            }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct StandaloneFab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                StandaloneFab(icon: "checkmark", color: .green) {}
            }
        }
    }
}
