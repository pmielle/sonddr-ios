//
//  TextExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

// title
// ----------------------------------------------
struct MyTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

extension View {
    func myTitle() -> some View {
        modifier(MyTitle())
    }
}
