//
//  RatingFab.swift
//  sonddr
//
//  Created by Paul Mielle on 09/12/2022.
//

import SwiftUI

struct RatingFab: View {

    // attributes
    // ------------------------------------------
    @State var rating: CGFloat
    let height = 2 * fabSize
    @State var maskHeight: CGFloat? = nil
    @State var icon: String? = nil
    @State var ratingOverride: CGFloat? = nil
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        Rectangle()
            .fill(LinearGradient(colors: [.cyan, .orange, .red], startPoint: .bottom, endPoint: .top))
            .frame(width: fabSize, height: self.height)
            .overlay {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(.black.opacity(0.66))
                        .mask(alignment: .top) {
                            Rectangle()
                                .frame(height: self.maskHeight ?? self.height)
                        }
                    Text(self.icon ?? "")
                        .font(.system(size: largeIconSize))
                        .padding(.bottom, 12)
                }
            }
            .cornerRadius(99)
            .onAppear {
                self.setIcon()
                self.updateMaskHeight()
            }
            .onChange(of: ratingOverride) { _ in
                withAnimation {
                    self.setIcon()
                    self.updateMaskHeight()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        self.ratingOverride = self.computeRatingFromLocation(location: drag.location)
                    }
                    .onEnded { val in
                        self.ratingOverride = nil
                    }
            )

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func computeRatingFromLocation(location: CGPoint) -> CGFloat {
        let boundedY = max(0, min(self.height, location.y))
        return 100 - (boundedY / self.height * 100)
    }
    
    func updateMaskHeight() {
        self.maskHeight = self.computeMaskHeight(rating: self.ratingOverride ?? self.rating)
    }
    
    func computeMaskHeight(rating: CGFloat) -> CGFloat {
        return self.height - self.height * rating / 100
    }
    
    func setIcon() {
        self.icon = self.chooseIcon(rating: self.ratingOverride ?? self.rating)
    }
    
    func chooseIcon(rating: CGFloat) -> String {
        return rating >= 50 ? "🔥" : "❄️"
    }
}

struct RatingFab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                HStack {
                    RatingFab(rating: 0)
                    RatingFab(rating: 25)
                    RatingFab(rating: 50)
                    RatingFab(rating: 75)
                    RatingFab(rating: 100)
                    
                }
            }
        }
    }
}
