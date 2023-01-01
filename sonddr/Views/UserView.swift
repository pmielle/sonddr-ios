//
//  UserView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct UserView: View {

    // attributes
    // ------------------------------------------
    // parameters
    let user: User
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    @EnvironmentObject var fab: FabService
    // constant
    // ...
    // state
    @State var ideas: [Idea]? = nil
    @State var showNavigationBarTitle = false
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    @State var negativeOffset: CGFloat = 0
    @State var leftHeaderHStackOffset: CGFloat = 0
    @State var inProfile = false
    
    
    // body
    // ------------------------------------------
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottomTrailing) { MyBackground()
                
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: false,
                    offsetChanged: self.onScroll
                ) {
                    VStack(spacing: 0) {
                        self.header(topInset: reader.safeAreaInsets.top)
                            .padding(.bottom, mySpacing)
                        IdeaList(
                            ideas: self.isLoading ? nil : self.ideas,
                            pinnedHeaderColor: myBackgroundColor,
                            sortBy: self.$sortBy
                        )
                        .allowsHitTesting(!self.isLoading)
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
                .scrollDisabled(self.isLoading)
                .coordinateSpace(name: "idea-list-container")  // needed in IdeaList to style the pinned headers
                .onChange(of: self.sortBy) { _ in
                    Task {
                        await self.getIdeas()
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                self.toolbar()
            }
            .toolbarBackground(myBackgroundColor, for: .navigationBar)
            .onAppear {
                self.initialLoad()
            }
            .onFabTap(notificationName: .goToDiscussionFabTap) {
                print("go to discussion...")
            }
            .stackFabMode(fab: self.fab, mode: .GoToDiscussion)
            
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(self.auth.loggedInUser!.name)
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
            Image("DefaultProfileCover")
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
                    .frame(height: coverPictureHeight - topInset - largeProfilePictureSize * 2/3)
                VStack(spacing: mySpacing) {
                    VStack(alignment: .center, spacing: 10) {
                        ProfilePicture(user: self.auth.loggedInUser!, large: true)
                        Text(self.auth.loggedInUser!.name)
                            .myTitle()
                            .myGutter()
                        HStack(spacing: 0) {
                            Text("Member since 2014 · ")  // TODO: user.memberSince
                            if self.isLoading {
                                Text("9 ideas").redacted(reason: .placeholder)
                            } else {
                                Text("\(self.ideas!.count) ideas")
                            }
                        }
                        .opacity(0.5)
                    }
                    self.externalLinks()
                    Text("User bio - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras auctor, eros vitae rhoncus cursus, urna justo hendrerit dolor, ut iaculis mi dolor eu enim. Donec ornare ex diam, id porta elit suscipit et.")
                        .frame(maxWidth: .infinity, alignment: .leading)  // so that very short bio alignment.leading
                        .myGutter()
                }
            }
        }
    }
    
    func externalLinks() -> some View {
        HeaderHStack(shadowColor: myBackgroundColor, additionalLeftPadding: self.leftHeaderHStackOffset) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: mySpacing) {
                    Image(systemName: "arrow.up.right.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: largeIconSize)
                        .opacity(0.5)
                    ForEach(self.user.externalLinks, id: \.self) { externalLink in
                        ExternalLinkButton(externalLink: externalLink)
                    }
                }
                Text("External links")
                    .opacity(0.5)
            }
            .readSize { newSize in
                self.leftHeaderHStackOffset = max(0, (UIScreen.main.bounds.width - newSize.width) / 2 - mySpacing)
            }
        }
    }
    
    
    // methods
    // ------------------------------------------
    func initialLoad() {
        Task {
            await self.getIdeas()
            if !self.forceLoadingState {
                self.isLoading = false
            }
        }
    }
    
    func getIdeas() async {
        do {
            self.ideas = try await self.db.getIdeas()
        } catch {
            print("an error occured: \(error)")
        }
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

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
            NavigationStack {
                UserView(user: dummyUser())
            }
            NavigationStack {
                UserView(user: dummyUser(), forceLoadingState: true)
            }
            .previewDisplayName("Loading")
        }
        .environmentObject(fab)
        .environmentObject(auth)
        .environmentObject(db)
    }
}
