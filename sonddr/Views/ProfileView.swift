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
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            ZStack() { MyBackground()
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: true,
                    offsetChanged: self.onScroll
                ) {
                    VStack(spacing: 0) {
                        self.header()
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
    
    func header() -> some View {
        VStack(alignment: .leading, spacing: mySpacing) {
            Text(self.auth.loggedInUser!.name)
                .myTitle()
                .myGutter()
                .padding(.top, mySpacing)
            Text("User bio - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras auctor, eros vitae rhoncus cursus, urna justo hendrerit dolor, ut iaculis mi dolor eu enim. Donec ornare ex diam, id porta elit suscipit et.")
                .myGutter()
            HeaderHStack(shadowColor: self.accentColor) {
                if self.isLoading {
                    // ...
                    // TODO: 2 dummy external links
                    // ...
                } else {
                    // ...
                    // TODO: foreach external link, display icon
                    // ...
                }
                Label("External link", systemImage: "plus.circle")
                    .myLabel(color: .white)
                    .foregroundColor(self.accentColor)
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
        if offset.y < 0 {
            // ...
        } else {
            // ...
        }
        // navigation bar title
        withAnimation(.easeIn(duration: myShortDurationInSec)) {
            self.showNavigationBarTitle = offset.y > 50
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
