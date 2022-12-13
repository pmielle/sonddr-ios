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
                self.setMaskHeight()
            }

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func setMaskHeight() {
        self.maskHeight = self.height - self.height * self.rating / 100
    }
    
    func setIcon() {
        self.icon = self.rating >= 50 ? "🔥" : "❄️"
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
