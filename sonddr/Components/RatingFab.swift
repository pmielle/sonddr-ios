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
    // parameters
    @State var rating: CGFloat
    // environment
    @EnvironmentObject var auth: AuthenticationService
    // constant
    let height = 2 * fabSize
    // state
    @State var maskHeight: CGFloat? = nil
    @State var icon: String? = nil
    @State var ratingOverride: CGFloat? = nil
    @State var userRating: CGFloat? = nil
    @State var bubbleLocation: CGFloat? = nil
    @State var bubbleVisible: Bool = false
    
    
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
            .cornerRadius(99)  // between the 2 so that only ProfilePicture overflows
            .overlay {
                self.userRatingBubble()
            }
            .onAppear {
                self.setIcon()
                self.updateMaskHeight()
                self.updateBubble()
            }
            .onChange(of: ratingOverride) { _ in
                self.updateMaskHeight()
                withAnimation(.linear(duration: myShortDurationInSec)) {
                    self.setIcon()
                    self.updateBubble()
                }
            }
            .onChange(of: userRating) { _ in
                Task {
                    withAnimation(.linear(duration: myShortDurationInSec)) {
                        self.updateBubbleVisible()
                    }
                    await sleep(seconds: myShortDurationInSec)
                    self.updateBubbleLocation()
                }
                
            }
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        self.ratingOverride = self.computeRatingFromLocation(location: drag.location)
                    }
                    .onEnded { val in
                        self.rate(rating: self.ratingOverride)
                        self.ratingOverride = nil
                    }
            )

    }
    
    
    // subviews
    // ------------------------------------------
    func userRatingBubble() -> some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(height: profilePictureSize + 4)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(profilePictureSize / 2, corners: [.bottomLeft, .topLeft, .topRight])
                .cornerRadius(2, corners: .bottomRight)
                .rotationEffect(Angle(degrees: -45))
            ProfilePicture(user: self.auth.loggedInUser!)
        }
        .scaleEffect(self.bubbleVisible ? 1 : 0.5, anchor: .trailing)
        .opacity(self.bubbleVisible ? 1 : 0)
        .position(x: 0, y: self.bubbleLocation ?? self.computeMaskHeight(rating: self.rating))
        .onTapGesture {
            self.rate(rating: nil)
        }
    }
    
    
    // methods
    // ------------------------------------------
    func rate(rating: CGFloat?) {
        self.userRating = rating
    }
    
    func updateBubble() {
        self.updateBubbleLocation()
        self.updateBubbleVisible()
    }
    
    func updateBubbleLocation() {
        self.bubbleLocation = self.computeBubbleLocationFromRating(rating: self.ratingOverride ?? self.userRating ?? nil)
    }
    
    func updateBubbleVisible() {
        self.bubbleVisible = self.ratingOverride != nil || self.userRating != nil
    }
    
    func computeBubbleLocationFromRating(rating: CGFloat?) -> CGFloat? {
        if (rating == nil) {
            return nil
        }
        let computedY = self.height - self.height * rating! / 100
        let padding: CGFloat = 5
        return min(self.height - padding, max(padding, computedY))
    }
    
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
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        return NavigationView {
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
        .environmentObject(auth)
    }
}
