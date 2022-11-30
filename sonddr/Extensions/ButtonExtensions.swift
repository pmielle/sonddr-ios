//
//  ButtonExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 24/11/2022.
//

import SwiftUI

struct MyLargeButton: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(self.color)
            .cornerRadius(20)
            .fontWeight(.bold)
    }
}

extension Button {
    func myLargeButton(color: Color) -> some View {
        modifier(MyLargeButton(color: color))
    }
}
