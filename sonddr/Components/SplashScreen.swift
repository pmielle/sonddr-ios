//
//  SplashScreen.swift
//  sonddr
//
//  Created by Paul Mielle on 23/11/2022.
//

import SwiftUI

struct SplashScreen: View {

    // attributes
    // ------------------------------------------
    @State var scaleUp = false
    @State var scaleDown = false
    @State var fadeOut = false
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        ZStack {
            Color("PrimaryColor")
            Image("SplashLarge")
                .resizable()
                .aspectRatio(contentMode: self.scaleUp ? .fill : .fit)
                .frame(width: self.scaleUp ? nil : 85)
                .scaleEffect(self.scaleDown ? 0.9 : 1)
                .frame(width: UIScreen.main.bounds.width)
        }
        .ignoresSafeArea()
        .opacity(self.fadeOut ? 0 : 1)
        .onAppear {
            Task {
                await sleep(seconds:myDurationInSec)
                withAnimation(.easeOut(duration: myShortDurationInSec)) {
                    self.scaleDown = true
                }
                await sleep(seconds: myShortDurationInSec)
                withAnimation(.easeIn(duration: myDurationInSec)) {
                    self.scaleUp = true
                }
                withAnimation(.easeIn(duration: myShortDurationInSec)) {
                    self.fadeOut = true
                }
            }
        }

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
