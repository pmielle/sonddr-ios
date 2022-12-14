//
//  PreferenceKeys.swift
//  sonddr
//
//  Created by Paul Mielle on 19/11/2022.
//

import SwiftUI

public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 0
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

public struct SizePreferenceKey: PreferenceKey {
  public static var defaultValue: CGSize = .zero
  public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

