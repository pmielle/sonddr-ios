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


// inline toolbar title
// ----------------------------------------------
struct MyInlineToolbarTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .frame(width: UIScreen.main.bounds.width - 2 * largeIconSize - 4 * mySpacing - 2 * myLargeSpacing)
            .font(.headline)
    }
}

extension View {
    func myInlineToolbarTitle() -> some View {
        modifier(MyInlineToolbarTitle())
    }
}
