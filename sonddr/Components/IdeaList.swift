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
    var showSortBy: Bool
    var pinnedHeaderColor: Color = myBackgroundColor
    @State var sections: [ListSection] = []
    @State private var pinnedHeaderIndex: Int? = nil
    
    
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
                        Section(
                            header: self.sectionHeader(
                                name: section.name,
                                index: i,
                                pinned: self.pinnedHeaderIndex == i
                            )
                            .onPreferenceChange(ViewOffsetKey.self) { offset in
                                if offset < 1 {
                                    self.pinnedHeaderIndex = i
                                } else if self.pinnedHeaderIndex == i {
                                    self.pinnedHeaderIndex = nil
                                }
                            }
                        ) {
                            ForEach(section.ideas) { idea in
                                IdeaCard(idea: idea)
                                    .padding(.bottom, mySpacing)
                                
                            }
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
    func sectionHeader(name: String, index: Int, pinned: Bool) -> some View {
        HStack {
            Text(name)
            Spacer()
            if (index == 0) {
                self.sortBy()
                    .opacity(self.showSortBy ? 1 : 0)
            }
        }
        .myGutter()
        .padding(.vertical, 15)
        .background(pinned ? self.pinnedHeaderColor : myBackgroundColor)
        .background(ZStack {
            myBackgroundColor
            GeometryReader { geom in
                Color.clear.preference(
                    key: ViewOffsetKey.self,
                    value: geom.frame(in: .named("idea-list-container")).origin.y
                )
            }
        
        })
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
                        dummyIdea(),
                        dummyIdea(),
                    ], showSortBy: true)
                }
            }
                .coordinateSpace(name: "idea-list-container")
        }
    }
}
