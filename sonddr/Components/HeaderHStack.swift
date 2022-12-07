//
//  HeaderHStack.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct HeaderHStack<T: View>: View {
    
    // attributes
    // ------------------------------------------
    let shadowColor: Color
    var additionalLeftPadding: CGFloat = 0
    @ViewBuilder var content: T
    @State var showLeftShadow = false
    let shadowWidth = largeIconSize
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ScrollViewWithOffset(
            axes: .horizontal,
            showsIndicators: false,
            offsetChanged: self.onScroll
        ) {
            HStack(spacing: mySpacing) {
                self.content
            }
            .myGutter()
            .padding(.leading, self.additionalLeftPadding)
            .padding(.trailing, self.shadowWidth)
        }
        .overlay(content: self.shadows)
        
    }
    
    // subviews
    // ------------------------------------------
    func shadows() -> some View {
        HStack {
            self.shadow(from: .leading)
                .opacity(self.showLeftShadow ? 1 : 0)
            Spacer()
            self.shadow(from: .trailing)
        }
        .allowsHitTesting(false)
    }
    
    func shadow(from: Alignment) -> some View {
        var startPoint: UnitPoint = .leading
        var endPoint: UnitPoint = .trailing
        switch from {
        case .leading:
            startPoint = .leading
            endPoint = .trailing
        case .trailing:
            startPoint = .trailing
            endPoint = .leading
        default:
            print("unhandled gradient direction: using .leading as fallback")
        }
        return Rectangle().fill(
            LinearGradient(colors: [self.shadowColor, .clear], startPoint: startPoint, endPoint: endPoint)
        )
        .frame(width: self.shadowWidth)
    }
    
    
    // methods
    // ------------------------------------------
    func onScroll(offset: CGPoint) {
        withAnimation(.easeIn(duration: myShortDurationInSec)) {
            self.showLeftShadow = (offset.x - self.additionalLeftPadding) >= 1
        }
    }
}

struct HeaderHStack_Previews: PreviewProvider {
    static var previews: some View {
        HeaderHStack(shadowColor: myBackgroundColor, additionalLeftPadding: 100) {
            Text("AAA")
            Text("BBB")
            Text("CCC")
            Text("DDD")
            Text("EEE")
            Text("FFF")
            Text("GGG")
            Text("HHH")
            Text("III")
            Text("JJJ")
        }
    }
}
