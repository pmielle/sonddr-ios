//
//  ScrollViewWithOffset.swift
//  sonddr
//
//  Created by Paul Mielle on 14/11/2022.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct ScrollViewWithOffset<T: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    @ViewBuilder var content: T
    
    var body: some View {
        ScrollView(self.axes, showsIndicators: self.showsIndicators) {
                self.content
                .background(alignment: .topLeading) {
                    GeometryReader { geometry in
                        let origin = geometry.frame(in: .named("scrollView"))
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: CGPoint(x: -1 * origin.minX, y: -1 * origin.maxY)
                        )
                    }.frame(width: 0, height: 0)
                }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: self.offsetChanged)
    }
}

struct ScrollViewWithOffset_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewWithOffset(axes: .vertical, showsIndicators: true, offsetChanged: {_ in }) {
            Text("foo")
        }
    }
}
