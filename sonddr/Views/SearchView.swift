//
//  SearchView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct SearchView: View {

    // attributes
    // ------------------------------------------
    // params
    var forceLoadingState = false
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    @EnvironmentObject var fab: FabService
    // constant
    let topViewId = randomId()
    // state
    @State var inProfile = false
    @State var inputText = ""
    @State var query: String? = nil
    @State var result: [Idea]? = nil
    @State var isLoading = false
    @State var sortBy: SortBy = .date
    @State var navigation = NavigationPath()
    @State var scrollViewOffset: CGFloat = 0

    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack(path: self.$navigation) {
            ZStack { MyBackground()
                ScrollViewReader { reader in
                    ZStack {
                        self.completion(proxy: reader)
                            .opacity(self.query == nil ? 1 : 0)
                        self.results(proxy: reader)
                    }
                }
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func results(proxy: ScrollViewProxy) -> some View {
        ScrollViewWithOffset(axes: .vertical, showsIndicators: false) { offset in
            self.scrollViewOffset = round(offset.y)
        } content: {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 0)
                    .id(self.topViewId)
                VStack(spacing: mySpacing) {
                    if self.query != nil {
                        self.resultCount()
                        IdeaList(
                            ideas: self.isLoading ? nil : self.result,
                            sortBy: self.$sortBy,
                            alwaysShowFirstSortBy: true
                        )
                        .allowsHitTesting(!self.isLoading)
                    }
                }
            }
            .padding(.bottom, 100)
            .onReceive(NotificationCenter.default.publisher(for: .searchBottomBarIconTap)) { _ in
                self.onBottomBarIconTap(proxy: proxy)
            }
            .onChange(of: self.sortBy) { _ in
                self.scrollToTop(proxy: proxy, animate: false)
                Task {
                    await self.getIdeas()
                }
            }
            .toolbar {
                self.toolbar(proxy: proxy)
            }
            .toolbarBackground(myBackgroundColor, for: .navigationBar)
            
        }
        .coordinateSpace(name: "idea-list-container")  // needed in IdeaList
        .scrollDisabled(self.isLoading)
        .navigationDestination(for: Idea.self) { idea in
            IdeaView(idea: idea)
        }
        .navigationDestination(for: Goal.self) { goal in
            GoalView(goal: goal, navigation: self.$navigation)
        }
        .navigationDestination(for: User.self) { user in
            UserView(user: user)
        }
    }
    
    func completion(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 0).padding(.top, mySpacing)
                VStack {
                    self.completionItem(text: "Dummy suggestion", proxy: proxy)
                    self.completionItem(text: "Dummy suggestion", proxy: proxy)
                }
            }
        }
    }
    
    func completionItem(text: String, proxy: ScrollViewProxy) -> some View {
        HStack(spacing: mySpacing) {
            Image(systemName: "arrow.up.right")
                .foregroundColor(myPrimaryColor)
            Text(text)
        }
        .padding(.top, 5)
        .myGutter()
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            self.inputText = text
            self.onSubmit(proxy: proxy)
        }
    }
    
    func resultCount() -> some View {
        let count = self.isLoading || self.result == nil ? 1 : self.result!.count
        return Text("\(count) result\(count > 1 ? "s" : "")")
            .redacted(reason: self.isLoading ? .placeholder : [])
            .frame(maxWidth: .infinity, alignment: .leading)
            .myGutter()
            .padding(.top, myLargeSpacing)
            .opacity(0.5)
    }
    
    @ToolbarContentBuilder
    func toolbar(proxy: ScrollViewProxy) -> some ToolbarContent {
        ToolbarItem {
            ProfilePicture(user: self.auth.loggedInUser!)
                .onTapGesture {
                    self.inProfile = true
                }
                .fullScreenCover(isPresented: self.$inProfile) {
                    ProfileView(isPresented: self.$inProfile)
                }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 5) {
                TextField("Search", text: self.$inputText)
                    .padding(.leading, 32)
                Button {
                    self.clear()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                }
                .opacity(self.inputText.isEmpty ? 0 : 1)
            }
            .frame(width: UIScreen.main.bounds.width - 2 * mySpacing - profilePictureSize - mySpacing)
            .onSubmit {
                self.onSubmit(proxy: proxy)
            }
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onBottomBarIconTap(proxy: ScrollViewProxy) {
        if (self.navigation.count > 0) {
            self.goBackToNavigationRoot()
        } else if (self.scrollViewOffset != 0) {
            self.scrollToTop(proxy: proxy)
        } else if (self.query != nil) {
            self.clear()
        }
    }
    
    func scrollToTop(proxy: ScrollViewProxy, animate: Bool = true) {
        withAnimation(animate ? .easeIn(duration: myDurationInSec) : nil) {
            proxy.scrollTo(self.topViewId)
        }
    }
    
    func goBackToNavigationRoot() {
        // FIXME: emptying the whole stack is not animated if count > 1
        // FIXME: tap mid-navigation breaks things
        self.navigation.removeLast(self.navigation.count)
        self.fab.modeStack[.Search]!.removeLast(self.fab.modeStack[.Search]!.count - 1)
    }
    
    func onSubmit(proxy: ScrollViewProxy) {
        if self.inputText == "" {
            self.clear()
            return
        }
        self.scrollToTop(proxy: proxy, animate: false)
        self.query = self.inputText
        Task {
            await self.getIdeas()
        }
    }
    
    func getIdeas() async {
        self.isLoading = true
        do {
            self.result = try await self.db.getIdeas()
        } catch {
            print("an error occured: \(error)")
        }
        if self.forceLoadingState == false {
            self.isLoading = false
        }
    }
    
    func clear() {
        self.result = nil
        self.query = nil
        self.inputText = ""
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        fab.selectedTab = .Ideas
        
        return Group {
            SearchView()
            SearchView(forceLoadingState: true)
                .previewDisplayName("Loading")
        }
        .environmentObject(auth)
        .environmentObject(db)
        .environmentObject(fab)
    }
}
