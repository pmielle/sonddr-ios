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
                VStack(alignment: .leading, spacing: 0) {
                    self.header()
                    CommentView(comment: self.comments.first!)
                    Label("See \(self.comments.count) comment\(self.comments.count > 1 ? "s" : "")", systemImage: "chevron.down")
                        .labelStyle(TrailingIcon())
                        .myLabel(color: .white)
                        .foregroundColor(myDarkBackgroundColor)
                        .padding(.horizontal, mySpacing)
                        .padding(.leading, profilePictureSize + mySpacing)
                }
            }
        }
        .padding(.bottom, myLargeSpacing)
        .background(myDarkBackgroundColor)
        
    }
    
    
    // subviews
    // ------------------------------------------
    func header() -> some View {
        HStack {
            Text("Today")
            Spacer()
            self.sortByButton()            
        }
        .myGutter()
        .padding(.vertical, 15)
    }
    
    func sortByButton() -> some View {
        Menu {
            Button("Date") { self.sortBy = .date }
                .disabled(self.sortBy == .date)
            Button("Rating") { self.sortBy = .rating }
                .disabled(self.sortBy == .rating)
        } label: {
            HStack {
                Text("Sort by")
                Image(systemName: "line.3.horizontal.decrease")
            }
        }
    }
    
    
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
