//
//  IdeaView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct IdeaView: View {
    
    // attributes
    // ------------------------------------------
    // parameters
    let idea: Idea
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    @EnvironmentObject var fab: FabService
    // constant
    let accentColor: Color = myBackgroundColor
    let fabTransitionThreshold: CGFloat = 150
    // state
    @State var isLoading = true
    @State var showNavigationBarTitle = false
    @State var negativeOffset: CGFloat = 0
    @State var inProfile = false
    @State var comments: [Comment] = [dummyComment(), dummyComment()]
    @State var previewCommentsSortBy: SortBy = .date
    @State var showCommentsFab = false
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .bottomTrailing) { MyBackground()
            GeometryReader {reader in
                
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: true,
                    offsetChanged: self.onScroll
                ) {
                    VStack(spacing: mySpacing) {
                        self.header(topInset: reader.safeAreaInsets.top)
                        self.content()
                        CommentsPreview(comments: self.comments, sortBy: self.$previewCommentsSortBy)
                            .redacted(reason: self.isLoading ? .placeholder : [])
                            .offsetIn(space: .named("idea-scroll-container")) { offset in
                                self.onCommentsPreviewOffsetChange(offset: offset, containerHeight: reader.size.height)
                            }
                        self.commentInput()
                    }
                    .background {
                        if self.showCommentsFab {
                            Color.clear
                                .stackFabModeOverride(fab: self.fab, mode: .Comment)
                        }
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                }
                .coordinateSpace(name: "idea-scroll-container")
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            self.toolbar()
        }
        .toolbarBackground(self.accentColor, for: .navigationBar)
        .onAppear {
            self.initialLoad()
        }
        .onChange(of: previewCommentsSortBy) { _ in
            self.getComments()
        }
        .onFabTap(notificationName: .commentFabTap) {
            print("comment fab tap...")
        }
        .stackFabMode(fab: self.fab, mode: .Rate)
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(self.idea.title)
                .myInlineToolbarTitle()
                .opacity(self.showNavigationBarTitle ? 1 : 0)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            ProfilePicture(user: self.auth.loggedInUser!)
                .onTapGesture {
                    self.inProfile = true
                }
                .fullScreenCover(isPresented: self.$inProfile) {
                    ProfileView(isPresented: self.$inProfile)
                }
        }
        
    }
    
    func cover(topInset: CGFloat) -> some View {
        GeometryReader { _ in
            Image(self.idea.cover)
                .resizable()
                .frame(height: coverPictureHeight + self.negativeOffset)
        }
        .frame(height: coverPictureHeight - topInset)
        .offset(y: -1 * (topInset + self.negativeOffset))
    }
    
    func header(topInset: CGFloat) -> some View {
        ZStack(alignment: .top) {
            self.cover(topInset: topInset)
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: coverPictureHeight - topInset - mySpacing - goalChipHeight)
                VStack(spacing: mySpacing) {
                    HeaderHStack(shadowColor: .clear, additionalLeftPadding: profilePictureSize + mySpacing) {
                        ForEach(self.idea.goals) { goal in
                            NavigationLink(value: goal) {
                                GoalChip(goal: goal)
                            }
                        }
                    }
                    Spacer().frame(height: 0)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(self.idea.title)
                            .myTitle()
                            .padding(.leading, profilePictureSize + 2 * mySpacing)
                        HStack(spacing: mySpacing) {
                            NavigationLink(value: self.idea.author) {
                                ProfilePicture(user: self.idea.author)
                            }
                            HStack(spacing: 0) {
                                NavigationLink(value: self.idea.author) {
                                    Text(self.idea.author.name)
                                        .fontWeight(.bold)
                                }
                                Text(" · \(prettyTimeDelta(date:self.idea.date))")
                                    .opacity(0.5)
                                Spacer()
                            }
                        }
                        .myGutter()
                    }
                    self.externalLinks()
                        .padding(.leading, profilePictureSize + mySpacing)
                }
            }
        }
    }
    
    func externalLinks() -> some View {
        return HeaderHStack(shadowColor: self.accentColor) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: mySpacing) {
                    Image(systemName: "arrow.up.right.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: largeIconSize)
                        .opacity(0.5)
                    ForEach(self.idea.externalLinks, id: \.self) { externalLink in
                        ExternalLinkButton(externalLink: externalLink)
                    }
                }
                Text("External links")
                    .opacity(0.5)
            }
        }
    }
    
    func content() -> some View {
        HStack(alignment: .top, spacing: mySpacing) {
            VStack {
                // TODO: body comments
            }
            .frame(width: profilePictureSize)
            Text(self.idea.content)
        }
        .myGutter()
        .padding(.vertical, myLargeSpacing)
    }
    
    func commentInput() -> some View {
        HStack(spacing: mySpacing) {
            ProfilePicture(user: self.auth.loggedInUser!)
            Text("What do you think?")
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: fabSize)
        .myGutter()
    }

    
    // methods
    // ------------------------------------------
    func onCommentsPreviewOffsetChange(offset: CGFloat, containerHeight: CGFloat) {
        let effectiveOffset = offset - containerHeight + bottomBarApproxHeight + self.fabTransitionThreshold
        self.showCommentsFab = effectiveOffset < 0
    }
    
    func initialLoad() {
        self.getComments()
        if !self.forceLoadingState {
            self.isLoading = false
        }
    }
    
    func getComments() {
        self.comments = [dummyComment(), dummyComment()]
    }
    
    func onScroll(offset: CGPoint) {
        // sticky top background
        self.negativeOffset = offset.y < 0 ? -1 * offset.y : 0
        // navigation bar title
        withAnimation(.easeIn(duration: myShortDurationInSec)) {
            self.showNavigationBarTitle = offset.y > coverPictureHeight
        }
    }
}


struct IdeaView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
            NavigationStack {
                IdeaView(idea: dummyIdea())
            }
            NavigationStack {
                IdeaView(idea: dummyIdea(), forceLoadingState: true)
            }
        }
        .environmentObject(fab)
        .environmentObject(db)
        .environmentObject(auth)
    }
}
