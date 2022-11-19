//
//  PreferenceKeys.swift
//  sonddr
//
//  Created by Paul Mielle on 19/11/2022.
//

import SwiftUI

public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
