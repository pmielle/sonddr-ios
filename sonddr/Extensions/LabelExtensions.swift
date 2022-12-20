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
    let border: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(self.color)
            .overlay(
                RoundedRectangle(cornerRadius: 99)
                    .stroke(self.border, lineWidth: 1)
            )
            .cornerRadius(99)
    }
}

extension View {
    func myLabel(color: Color, border: Color = .clear) -> some View {
        modifier(MyLabel(color: color, border: border))
    }
}

// trailing
struct TrailingIcon: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}
