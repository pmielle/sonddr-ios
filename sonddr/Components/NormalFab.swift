//
//  NormalFab.swift
//  sonddr
//
//  Created by Paul Mielle on 09/12/2022.
//

import SwiftUI

struct NormalFab: View {

    // attributes
    // ------------------------------------------
    let color: Color
    let icon: String
    var secondaryIcon: String? = nil
    
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        Rectangle()
            .fill(self.color)
            .cornerRadius(99)
            .frame(width: fabSize, height: fabSize)
            .overlay {
                ZStack {
                    Image(systemName: self.icon)
                    if self.secondaryIcon != nil {
                        Image(systemName: self.secondaryIcon!)
                            .scaleEffect(0.8)
                            .offset(x: 10, y: 10)
                    }
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

struct NormalFab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                
                VStack {
                    NormalFab(color: myPrimaryColor, icon: "lightbulb", secondaryIcon: "plus")
                    NormalFab(color: myGreenColor, icon: "checkmark")
                    NormalFab(color: myBlueColor, icon: "arrowshape.turn.up.right")
                    NormalFab(color: .red, icon: "rectangle.portrait.and.arrow.right")
                }
                
            }
        }
    }
}
