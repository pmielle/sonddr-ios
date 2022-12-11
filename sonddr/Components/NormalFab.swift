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
    @Binding var color: Color
    @Binding var icon: String
    @Binding var secondaryIcon: String?
    
    
    
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
                    NormalFab(color: .constant(myPrimaryColor), icon: .constant("lightbulb"), secondaryIcon: .constant("plus"))
                    NormalFab(color: .constant(.green), icon: .constant("checkmark"), secondaryIcon: .constant(nil))
                    NormalFab(color: .constant(.blue), icon: .constant("arrowshape.turn.up.right"), secondaryIcon: .constant(nil))
                    NormalFab(color: .constant(.red), icon: .constant("rectangle.portrait.and.arrow.right"), secondaryIcon: .constant(nil))
                }
                
            }
        }
    }
}
