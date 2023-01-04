//
//  AddView.swift
//  sonddr
//
//  Created by Paul Mielle on 30/11/2022.
//

import SwiftUI

struct AddView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    let preselectedGoal: Goal?
    let addCallback: (Idea) -> Void
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constant
    let accentColor: Color = myBackgroundColor
    let coverPlaceholderColor: Color = .gray
    // state
    @State var negativeOffset: CGFloat = 0
    @State var selectedGoals: [Goal] = []
    @State var title = ""
    @State var content = ""
    @State var coverImage = "DefaultIdeaCover"
    
    
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
                        showsIndicators: false,
                        offsetChanged: self.onScroll
                    ) {
                        VStack(spacing: 0) {
                            self.header(topInset: reader.safeAreaInsets.top)
                                .padding(.bottom, mySpacing)
                            HStack(alignment: .top, spacing: mySpacing) {
                                ProfilePicture(user: self.auth.loggedInUser!)
                                TextField("Explain your idea", text: self.$content)
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)  // so that very short bio alignment.leading
                            }
                            .myGutter()
                            Spacer()
                        }
                        .padding(.bottom, 100)
                    }
                    
                    // fab
                    StandaloneFab(icon: "checkmark", color: myGreenColor) {
                        self.onSubmit()
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                    .padding(.trailing, mySpacing)
                
                }
                .toolbar {
                    self.toolbar()
                }
                .navigationTitle("Share an idea")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(myBackgroundColor, for: .navigationBar)
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
    }
    
    func cover(topInset: CGFloat) -> some View {
            GeometryReader { _ in
                Color.gray
                    .frame(height: coverPictureHeight + self.negativeOffset)
            }
            .frame(height: coverPictureHeight - topInset)
            .offset(y: -1 * (topInset + self.negativeOffset))
            .overlay {
                // upload icon
                VStack(spacing: 6) {
                    Image(systemName: "icloud.and.arrow.up")
                    Text("Upload a cover")
                }
                .offset(y: -1 * (goalChipHeight + mySpacing) / 2)
                .foregroundColor(myBackgroundColor)
            }
    }
    
    func header(topInset: CGFloat) -> some View {
        ZStack (alignment: .top) {
            self.cover(topInset: topInset)
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: coverPictureHeight - topInset - goalChipHeight - mySpacing)
                VStack(alignment: .leading, spacing: 2 * mySpacing) {
                    HeaderHStack(shadowColor: self.coverPlaceholderColor, additionalLeftPadding: mySpacing + profilePictureSize) {
                        self.goalPicker()
                        ForEach(self.selectedGoals) { selectedGoal in
                            GoalChip(goal: selectedGoal)
                        }
                    }
                    .onAppear {
                        if self.preselectedGoal != nil {
                            self.selectedGoals.append(self.preselectedGoal!)
                        }
                    }
                    TextField("Choose a title", text: self.$title)
                        .myTitle()
                        .myGutter()
                        .padding(.leading, mySpacing + profilePictureSize)
                }
                .foregroundColor(self.coverPlaceholderColor)
            }
        }
    }
    
    func goalPicker() -> some View {
        Menu {
            ForEach(self.db.goals!) { goal in
                if !self.selectedGoals.contains(goal) {
                    Button(goal.name) {
                        self.selectedGoals.append(goal)
                    }
                }
            }
        } label: {
            Label("Goal(s) of interest", systemImage: "plus.circle")
                .myLabel(color: myBackgroundColor)
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onSubmit() {
        // validate the inputs
        let id = randomId()
        let title = self.title
        if title.isEmpty {
            print("[error] please choose a title")
            return
        }
        let author = self.auth.loggedInUser!
        let goals = self.selectedGoals
        if goals.count == 0 {
            print("[error] please select at least one goal")
            return
        }
        let cover = self.coverImage
        let rating = 50
        let date = Date.now
        let externalLinks: [ExternalLink] = []
        let content = self.content
        if content.isEmpty {
            print("[error] please explain your idea")
            return
        }
        // build the idea
        let idea = Idea(
            id: id,
            title: title,
            author: author,
            goals: goals,
            cover: cover,  // TODO: an actual image
            rating: rating,
            date: date,
            externalLinks: externalLinks,
            content: content)
        // post it to the parent view
        self.addCallback(idea)
        // dismiss
        self.isPresented = false
    }
    
    func onScroll(offset: CGPoint) {
        // sticky top background
        self.negativeOffset = offset.y < 0 ? -1 * offset.y : 0
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        return Group {
            AddView(isPresented: .constant(true), preselectedGoal: nil) { newIdea in
                print("newIdea is \(newIdea)")
            }
            
            AddView(isPresented: .constant(true), preselectedGoal: dummyGoal()) { newIdea in
                print("newIdea is \(newIdea)")
            }
            .previewDisplayName("Preselected goal")
        }
        .environmentObject(auth)
        .environmentObject(db)
    }
}
