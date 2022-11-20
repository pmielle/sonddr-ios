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
    @State private var sections: [ListSection] = []
    @State private var pinnedHeaderIndexes: [Int] = []
    
    
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
                        }
                        .onPreferenceChange(ViewOffsetKey.self) { offset in
                            self.processHeaderOffsetChange(offset: offset, index: i)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.formatData()
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
                self.sortBy()
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
        .background(
            GeometryReader { geom in
                Color.clear.preference(
                    key: ViewOffsetKey.self,
                    value: geom.frame(in: .named("idea-list-container")).origin.y
                )
            }
        )
    }
    
    func sortBy() -> some View {
        Button(action: {}) {
            Text("Sort by")
            Image(systemName: "line.3.horizontal.decrease")
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
                self.pinnedHeaderIndexes.append(index)
            }
        } else if self.pinnedHeaderIndexes.contains(index) {
            self.pinnedHeaderIndexes.removeAll { elem in
                elem == index
            }
        }
    }
    
    func formatData() {
        // init
        var todaySection = ListSection(name: "Today", ideas: [])
        var thisWeekSection = ListSection(name: "This week", ideas: [])
        var earlierSection = ListSection(name: "Earlier", ideas: [])
        // dispatch
        self.ideas.forEach { idea in
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

private struct ListSection {
    let name: String
    var ideas: [Idea]
}

private enum SortBy {
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
                    ], pinnedHeaderColor: .red)
                }
            }
            .coordinateSpace(name: "idea-list-container")
        }
    }
}
