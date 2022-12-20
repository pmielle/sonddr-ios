//
//  CommentsPreview.swift
//  sonddr
//
//  Created by Paul Mielle on 20/12/2022.
//

import SwiftUI

struct CommentsPreview: View {

    // attributes
    // ------------------------------------------
    let comments: [Comment]
    @Binding var sortBy: SortBy
    
    
    // body
    // ------------------------------------------
    var body: some View {
        VStack {
            if self.comments.count == 0 {
                Text("No comments...")
            } else {
                VStack(alignment: .leading) {
                    CommentView(comment: self.comments.first!)
                    Label("See \(self.comments.count) comment\(self.comments.count > 1 ? "s" : "")", systemImage: "chevron.down")
                        .labelStyle(TrailingIcon())
                        .myLabel(color: .clear, border: .white)
                        .foregroundColor(.white)
                        .padding(.horizontal, mySpacing)
                        .padding(.leading, profilePictureSize + mySpacing)
                }
            }
        }
        .padding(.bottom, myLargeSpacing)
        .background(.black.opacity(0.5))

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct CommentsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack { MyBackground()
            CommentsPreview(comments: [dummyComment(), dummyComment()], sortBy: .constant(.date))
        }
    }
    
}
