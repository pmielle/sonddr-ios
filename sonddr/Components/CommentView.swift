//
//  CommentView.swift
//  sonddr
//
//  Created by Paul Mielle on 20/12/2022.
//

import SwiftUI

struct CommentView: View {

    // attributes
    // ------------------------------------------
    let comment: Comment
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        Grid(horizontalSpacing: mySpacing, verticalSpacing: 0) {
            GridRow {
                ProfilePicture(user: self.comment.from)
                HStack(spacing: 0) {
                    Text(self.comment.from.name)
                        .fontWeight(.bold)
                    Text(" · \(prettyTimeDelta(date:self.comment.date))")
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GridRow(alignment: .top) {
                VStack(spacing: 5) {
                    Button {
                        print("upvote \(self.comment.id)")
                    } label: {
                        Image(systemName: "chevron.up")
                            .opacity(0.5)
                    }
                    Text("\(self.comment.score)")
                        .foregroundColor(
                            self.comment.score == 0 ? .white
                            : self.comment.score > 0 ? .green
                            : .red)
                    Button {
                        print("downvote \(self.comment.id)")
                    } label: {
                        Image(systemName: "chevron.down")
                            .opacity(0.5)
                    }
                }
                .padding(.vertical, mySpacing)
                Text(self.comment.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(mySpacing)

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: dummyComment())
    }
}
