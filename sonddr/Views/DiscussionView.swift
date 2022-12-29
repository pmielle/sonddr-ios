//
//  DiscussionView.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct DiscussionView: View {

    // attributes
    // ------------------------------------------
    // parameters
    let discussion: Discussion
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack() { MyBackground()
            
            Text("DiscussionView works!")
            
        }
    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiscussionView(discussion: dummyDiscussion())
        }
    }
}
