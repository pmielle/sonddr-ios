//
//  CommentsView.swift
//  sonddr
//
//  Created by Paul Mielle on 02/01/2023.
//

import SwiftUI

struct CommentsView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    @Binding var sortBy: SortBy
    let title: String
    let comments: [Comment]
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constants
    // ...
    // state
    @State var inputText = ""
    @State var sections: [ListSection<Comment>] = []
    @State var pinnedHeaderIndexes: [Int] = []
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            GeometryReader {reader in
                ZStack(alignment: .bottomTrailing) { MyBackground()
                    
                    // main
                    VStack(spacing: 0) {
                        
                        // content
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: mySpacing) {
                                self.header()
                                self.commentList()
                            }
                        }
                        .background(myDarkBackgroundColor)
                        .coordinateSpace(name: "comment-list-container")
                        
                        // message input
                        HStack(spacing: mySpacing) {
                            ProfilePicture(user: self.auth.loggedInUser!)
                            Text("What do you think?")
                                .opacity(0.5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: fabSize)
                        .myGutter()
                        .padding(.vertical, mySpacing)
                        .padding(.trailing, mySpacing + fabSize)
                    }
                    .padding(.bottom, bottomBarApproxHeight)
                    
                    // fab
                    StandaloneFab(icon: "paperplane", color: myGreenColor) {
                        print("send comment...")
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                    .padding(.trailing, mySpacing)
                
                }
                .toolbar {
                    self.toolbar()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(myDarkBackgroundColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    self.formatData(comments: self.comments)
                }
                .onChange(of: comments) { newValue in
                    self.formatData(comments: newValue)
                }
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "xmark")
                .onTapGesture {
                    self.isPresented = false
                }
        }
        ToolbarItem(placement: .principal) {
            Text(self.title)
                .myInlineToolbarTitle()
        }
    }
    
    func header() -> some View {
        VStack {
            Text("\(self.comments.count) comments")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .myGutter()
        .padding(.top, mySpacing)
    }
    
    func commentList() -> some View {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            if self.sections.count > 0 {
                ForEach(
                    (0...self.sections.count - 1),
                    id: \.self
                ) { i in
                    let section = self.sections[i]
                    Section {
                        ForEach(section.items) { comment in
                            CommentView(comment: comment)
                                .padding(.bottom, mySpacing)
                        }
                    } header: {
                        self.sectionHeader(
                            name: section.name,
                            index: i
                        )
                        .offsetIn(space: .named("comment-list-container")) { offset in
                            self.processHeaderOffsetChange(offset: offset, index: i)
                        }
                    }
                }
            }
        }
    }
    
    func sectionHeader(name: String, index: Int) -> some View {
        let isPinned = self.pinnedHeaderIndexes.contains(index)
        return HStack {
            Text(name)
            Spacer()
            if (index == 0) {
                self.sortByButton()
                    .opacity(self.pinnedHeaderIndexes.count == 0 ? 1 : 0)
            }
        }
        .myGutter()
        .padding(.vertical, 15)
        .background(myDarkBackgroundColor)
        .overlay(alignment: .bottom) {
            if isPinned {
                Color.gray
                    .opacity(0.5)
                    .frame(height: 0.5)
                    
            }
        }
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
    func processHeaderOffsetChange(offset: CGFloat, index: Int) {
        if offset == 0 {  // because it sometimes outputs 0.0s that I don't understand...
            return
        }
        if offset < 50 {
            if !self.pinnedHeaderIndexes.contains(index) {
                withAnimation(.easeIn(duration: myShortDurationInSec)) {
                    self.pinnedHeaderIndexes.append(index)
                }
            }
        } else if self.pinnedHeaderIndexes.contains(index) {
            withAnimation(.easeIn(duration: myShortDurationInSec)) {
                self.pinnedHeaderIndexes.removeAll { elem in
                    elem == index
                }
            }
        }
    }
    
    func formatData(comments: [Comment]?) {
        // init
        var todaySection = ListSection<Comment>(name: "Today", items: [])
        var thisWeekSection = ListSection<Comment>(name: "This week", items: [])
        var earlierSection = ListSection<Comment>(name: "Earlier", items: [])
        // guard: nil case
        if comments == nil {
            self.sections = []
            return
        }
        comments!.forEach { comment in
            let delta = Date.now.timeIntervalSince(comment.date)
            if delta <= 24 * 3600 {
                todaySection.items.append(comment)
            } else if delta <= 24 * 3600 * 7 {
                thisWeekSection.items.append(comment)
            } else {
                earlierSection.items.append(comment)
            }
        }
        // discard empty sections
        var newValue: [ListSection<Comment>] = []
        [todaySection, thisWeekSection, earlierSection].forEach { section in
            if !section.items.isEmpty {
                newValue.append(section)
            }
        }
        // assign
        self.sections = newValue
    }
    
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        return CommentsView(
            isPresented: .constant(true),
            sortBy: .constant(.date),
            title: "Dummy idea title",
            comments: [dummyComment(), dummyComment()])
            .environmentObject(db)
            .environmentObject(auth)
    }
}
