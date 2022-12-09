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
    // state
    @State var showNavigationBarTitle = false
    @State var negativeOffset: CGFloat = 0
    @State var inProfile = false
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .bottomTrailing) { MyBackground()
            GeometryReader {reader in
                
                // main content
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: true,
                    offsetChanged: self.onScroll
                ) {
                    VStack(spacing: myLargeSpacing) {
                        self.header(topInset: reader.safeAreaInsets.top)
                            .padding(.bottom, mySpacing)
                        self.content()
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
                
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            self.toolbar()
        }
        .toolbarBackground(self.accentColor, for: .navigationBar)
        .stackFabMode(fab: self.fab, mode: nil)
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
    }
    
    
    // methods
    // ------------------------------------------
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
        
        return NavigationStack {
            IdeaView(idea: dummyIdea())
        }
        .environmentObject(fab)
        .environmentObject(db)
        .environmentObject(auth)
    }
}
