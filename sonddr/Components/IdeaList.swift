//
//  IdeaLIst.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct IdeaList: View {
    
    // attributes
    // ------------------------------------------
    var ideas: [Idea]
    var pinnedHeaderColor: Color = myBackgroundColor
    @Binding var sortBy: SortBy
    @State var sections: [ListSection] = []
    @State var pinnedHeaderIndexes: [Int] = []
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                if self.sections.count > 0 {
                    ForEach(
                        (0...self.sections.count - 1),
                        id: \.self
                    ) { i in
                        let section = self.sections[i]
                        Section {
                            ForEach(section.ideas) { idea in
                                IdeaCard(idea: idea)
                                    .padding(.bottom, mySpacing)
                                
                            }
                        } header: {
                            self.sectionHeader(
                                name: section.name,
                                index: i
                            )
                            .background(
                                GeometryReader { geom in
                                    Color.clear.preference(
                                        key: ViewOffsetKey.self,
                                        value: geom.frame(in: .named("idea-list-container")).origin.y
                                    )
                                }
                            )
                        }
                        .onPreferenceChange(ViewOffsetKey.self) { offset in
                            self.processHeaderOffsetChange(offset: offset, index: i)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.formatData(ideas: self.ideas)
        }
        .onChange(of: ideas) { newValue in
            self.formatData(ideas: newValue)
        }
    }
    
    
    // subviews
    // ------------------------------------------
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
        .background(
            isPinned || index == 0 && self.pinnedHeaderIndexes.count == 0
            ? self.pinnedHeaderColor
            : myBackgroundColor
        )
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
        .buttonStyle(.plain)
    }
    
    
    // methods
    // ------------------------------------------
    func processHeaderOffsetChange(offset: Double, index: Int) {
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
    
    func formatData(ideas: [Idea]) {
        // init
        var todaySection = ListSection(name: "Today", ideas: [])
        var thisWeekSection = ListSection(name: "This week", ideas: [])
        var earlierSection = ListSection(name: "Earlier", ideas: [])
        // dispatch
        ideas.forEach { idea in
            let delta = Date.now.timeIntervalSince(idea.date)
            if delta <= 24 * 3600 {
                todaySection.ideas.append(idea)
            } else if delta <= 24 * 3600 * 7 {
                thisWeekSection.ideas.append(idea)
            } else {
                earlierSection.ideas.append(idea)
            }
        }
        // discard empty sections
        var newValue: [ListSection] = []
        [todaySection, thisWeekSection, earlierSection].forEach { section in
            if !section.ideas.isEmpty {
                newValue.append(section)
            }
        }
        // assign
        self.sections = newValue

    }
}

struct ListSection {
    let name: String
    var ideas: [Idea]
}

enum SortBy {
    case date
    case rating
}

struct IdeaList_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                ZStack { MyBackground()
                ScrollView {
                    IdeaList(ideas: [
                        dummyIdea(),
                        Idea(
                            id: randomId(),
                            title: "OLDER OMG",
                            author: dummyUser(),
                            goals: [dummyGoal(), dummyGoal()],
                            cover: "DefaultIdeaCover",
                            rating: 66,
                            date: Date.distantPast
                        ),
                        Idea(
                            id: randomId(),
                            title: "OLDER OMG",
                            author: dummyUser(),
                            goals: [dummyGoal(), dummyGoal()],
                            cover: "DefaultIdeaCover",
                            rating: 66,
                            date: Date.distantPast
                        ),
                        Idea(
                            id: randomId(),
                            title: "OLDER OMG",
                            author: dummyUser(),
                            goals: [dummyGoal(), dummyGoal()],
                            cover: "DefaultIdeaCover",
                            rating: 66,
                            date: Date.distantPast
                        ),
                        dummyIdea(),
                        dummyIdea(),
                    ], pinnedHeaderColor: .red, sortBy: .constant(.date))
                }
            }
            .coordinateSpace(name: "idea-list-container")
        }
        
        
        // 2nd preview with loading state
        // ------------------------------
        loadingIdeaList(pinnedHeaderColor: .red)
    }
}

func loadingIdeaList(pinnedHeaderColor: Color) -> some View {
    VStack(spacing: 0) {
        // header
        HStack() {
            Rectangle().fill(myLoadingColor)
                .frame(width: 50, height: 20)
            Spacer()
            Rectangle().fill(myLoadingColor)
                .frame(width: 90, height: 20)
        }
        .myGutter()
        .padding(.vertical, 15)
        .background(pinnedHeaderColor)
        // list
        VStack(spacing: 0) {
            loadingIdeaCard()
                .padding(.bottom, mySpacing)
            loadingIdeaCard()
                .padding(.bottom, mySpacing)
        }
    }
}
