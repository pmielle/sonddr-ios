//
//  RatingBadge.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct RatingBadge: View {
    let rating: Int
    let width: CGFloat = 60
    let maxRating: Int = 100
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.cyan, .yellow, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: self.width, height: largeIconSize)
            .overlay {
                ZStack(alignment: .leading) {
                    // mask
                    Rectangle()
                        .fill(.brown.opacity(0.9))
                        .offset(x: self.computeOffset())
                    // icon
                    Text(self.chooseIcon())
                        .padding(.leading, 5)
                }
            }
            .cornerRadius(99)
    }
    
    // methods
    // ------------------------------------------
    func computeOffset() -> CGFloat {
        let ratio = CGFloat(self.rating) / CGFloat(self.maxRating)
        let offset = ratio * self.width
        return offset
    }
    
    func chooseIcon() -> String {
        return self.rating >= 50 ? "🔥" : "❄️"
    }
}

struct RatingBadge_Previews: PreviewProvider {
    static var previews: some View {
        RatingBadge(rating: 0)
        RatingBadge(rating: 33)
        RatingBadge(rating: 50)
        RatingBadge(rating: 66)
        RatingBadge(rating: 100)
    }
}
