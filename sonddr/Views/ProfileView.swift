//
//  ProfileView.swift
//  sonddr
//
//  Created by Paul Mielle on 30/11/2022.
//

import SwiftUI

struct ProfileView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    var forceLoadingState: Bool = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constant
    let accentColor: Color = myBackgroundColor
    // state
    @State var ideas: [Idea]? = nil
    @State var showNavigationBarTitle = false
    @State var sortBy: SortBy = .date
    @State var isLoading = true
    @State var negativeOffset: CGFloat = 0
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            GeometryReader {reader in
                ZStack(alignment: .bottomTrailing) { MyBackground()
                    
                    // main content
                    ScrollViewWithOffset(
                        axes: .vertical,
                        showsIndicators: true,
                        offsetChanged: self.onScroll
                    ) {
                        VStack(spacing: 0) {
                            self.header(topInset: reader.safeAreaInsets.top)
                                .padding(.bottom, mySpacing)
                            IdeaList(
                                ideas: self.isLoading ? nil : self.ideas,
                                pinnedHeaderColor: self.accentColor,
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
                    
                    // fab
                    StandaloneFab(icon: "rectangle.portrait.and.arrow.right", color: .red) {
                        print("log out...")
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                    .padding(.trailing, mySpacing)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    self.toolbar()
                }
                .toolbarBackground(self.accentColor, for: .navigationBar)
                .onAppear {
                    self.initialLoad()
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
            Text(self.auth.loggedInUser!.name)
                .font(.headline)
                .opacity(self.showNavigationBarTitle ? 1 : 0)
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
                    HeaderHStack(shadowColor: self.accentColor) {  // TODO: center content
                        if self.isLoading {
                            ExternalLinkButton(externalLink: dummyExternalLink())
                        } else {
                            ForEach(self.auth.loggedInUser!.externalLinks, id: \.self) { externalLink in
                                ExternalLinkButton(externalLink: externalLink)
                                
                            }
                        }
                        Label("External link", systemImage: "plus.circle")
                            .myLabel(color: .white)
                            .foregroundColor(self.accentColor)
                    }
                    Text("User bio - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras auctor, eros vitae rhoncus cursus, urna justo hendrerit dolor, ut iaculis mi dolor eu enim. Donec ornare ex diam, id porta elit suscipit et.")
                        .frame(maxWidth: .infinity, alignment: .leading)  // so that very short bio alignment.leading
                        .myGutter()
                }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        return Group {
            
            NavigationView {
                ProfileView(isPresented: .constant(true))
            }
            
            // 2nd preview with loading state
            // ------------------------------
            NavigationView {
                ProfileView(isPresented: .constant(true), forceLoadingState: true)
            }
        }
        .environmentObject(db)
        .environmentObject(auth)
    }
}
