//
//  MessageComponent.swift
//  sonddr
//
//  Created by Paul Mielle on 31/12/2022.
//

import SwiftUI

struct MessageComponent: View {

    // attributes
    // ------------------------------------------
    // params
    let message: MyMessage
    let fromLoggedInUser: Bool
    let nextIsFromSameUser: Bool
    let parentWidth: CGFloat
    // environment
    @EnvironmentObject var db: DatabaseService
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        HStack(spacing: 0) {
            if self.fromLoggedInUser { Spacer() }
            Text(self.message.body)
                .padding(.vertical, mySpacing / 2)
                .padding(.horizontal, 12)
                .background(self.fromLoggedInUser ? myBlueColor : .white.opacity(0.33))
                .cornerRadius(mySpacing, corners: self.chooseRoundedCorners())
                .frame(
                    maxWidth: self.parentWidth * 0.8,
                    alignment: self.fromLoggedInUser ? .trailing : .leading)
            if !self.fromLoggedInUser { Spacer() }
        }
        .padding(.bottom, self.nextIsFromSameUser ? 5 : mySpacing)
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    func chooseRoundedCorners() -> UIRectCorner {
        if self.nextIsFromSameUser {
            return .allCorners
        }
        return self.fromLoggedInUser
        ? [.bottomLeft, .topLeft, .topRight]
        : [.bottomRight, .topLeft, .topRight]
    }
}

struct MessageComponent_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let parentWidth = UIScreen.main.bounds.width
        return Group {
            NavigationView {
                ZStack { MyBackground()
                    VStack(spacing: 0) {
                
                        MessageComponent(
                            message: dummyMessage(from: dummyUser()),
                            fromLoggedInUser: true,
                            nextIsFromSameUser: false,
                            parentWidth: parentWidth
                        )
                        
                        MessageComponent(
                            message: dummyMessage(from: dummyUser()),
                            fromLoggedInUser: false,
                            nextIsFromSameUser: true,
                            parentWidth: parentWidth
                        )
                        
                        MessageComponent(
                            message: dummyMessage(from: dummyUser()),
                            fromLoggedInUser: false,
                            nextIsFromSameUser: false,
                            parentWidth: parentWidth
                        )
                        
                        MessageComponent(
                            message: dummyMessage(from: dummyUser()),
                            fromLoggedInUser: true,
                            nextIsFromSameUser: true,
                            parentWidth: parentWidth
                        )
                        
                        MessageComponent(
                            message: dummyMessage(from: dummyUser()),
                            fromLoggedInUser: true,
                            nextIsFromSameUser: false,
                            parentWidth: parentWidth
                        )
                        
                    }
                }
            }
        }
        .environmentObject(db)
    }
}
