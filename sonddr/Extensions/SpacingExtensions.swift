//
//  SpacingExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 17/11/2022.
//

import SwiftUI


// gutter
// ----------------------------------------------
struct MyGutter: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, mySpacing)
    }
}

extension View {
    func myGutter() -> some View {
        modifier(MyGutter())
    }
}
