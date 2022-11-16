//
//  LabelExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

// goal chip
// ----------------------------------------------
struct MyLabel: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(self.color)
            .cornerRadius(99)
    }
}

extension View {
    func myLabel(color: Color) -> some View {
        modifier(MyLabel(color: color))
    }
}
