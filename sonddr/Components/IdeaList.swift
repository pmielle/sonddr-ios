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
    var ideas: [Idea]?  // nil upon first load
    var pinnedHeaderColor: Color = myBackgroundColor
    @Binding var sortBy: SortBy
    @State var sections: [ListSection<Idea>] = []
    @State var pinnedHeaderIndexes: [Int] = []
    var alwaysShowFirstSortBy = false
    
    
    // body
    // ------------------------------------------
    var body: some View {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            if self.ideas == nil {
                Section {
                    IdeaCard(idea: dummyIdea()).redacted(reason: .placeholder)
                    IdeaCard(idea: dummyIdea()).redacted(reason: .placeholder)
                } header: {
                    self.sectionHeader(name: "Placeholder", index: 0).redacted(reason: .placeholder)
                }
            } else if self.sections.count > 0 {
                ForEach(
                    (0...self.sections.count - 1),
                    id: \.self
                ) { i in
                    let section = self.sections[i]
                    Section {
                        ForEach(section.items) { idea in
                            IdeaCard(idea: idea)
                                .padding(.bottom, mySpacing)
                            
                        }
                    } header: {
                        self.sectionHeader(
                            name: section.name,
                            index: i
                        )
                        .offsetIn(space: .named("idea-list-container")) { offset in
                            self.processHeaderOffsetChange(offset: offset, index: i)
                        }
                    }
                }
            }
        }
        .onFirstAppear {
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
                    .opacity(self.pinnedHeaderIndexes.count == 0 || self.alwaysShowFirstSortBy ? 1 : 0)
            }
        }
        .myGutter()
        .padding(.vertical, 15)
        .background(
            isPinned || index == 0 && self.pinnedHeaderIndexes.count == 0
            ? self.pinnedHeaderColor
            : myBackgroundColor
        )
        .overlay(alignment: .bottom) {
            if isPinned {
                Color.gray
                    .opacity(0.5)
                    .frame(height: 0.5)
                    
            }
        }
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
    }
    
    
    // methods
    // ------------------------------------------
    func processHeaderOffsetChange(offset: CGFloat, index: Int) {
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
    
    func formatData(ideas: [Idea]?) {
        // init
        var todaySection = ListSection<Idea>(name: "Today", items: [])
        var thisWeekSection = ListSection<Idea>(name: "This week", items: [])
        var earlierSection = ListSection<Idea>(name: "Earlier", items: [])
        // guard: nil case
        if ideas == nil {
            self.sections = []
            return
        }
        ideas!.forEach { idea in
            let delta = Date.now.timeIntervalSince(idea.date)
            if delta <= 24 * 3600 {
                todaySection.items.append(idea)
            } else if delta <= 24 * 3600 * 7 {
                thisWeekSection.items.append(idea)
            } else {
                earlierSection.items.append(idea)
            }
        }
        // discard empty sections
        var newValue: [ListSection<Idea>] = []
        [todaySection, thisWeekSection, earlierSection].forEach { section in
            if !section.items.isEmpty {
                newValue.append(section)
            }
        }
        // assign
        self.sections = newValue
    }
}

struct ListSection<T> {
    let name: String
    var items: [T]
}

enum SortBy {
    case date
    case rating
}

struct IdeaList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZStack { MyBackground()
                ScrollView {
                    IdeaList(
                        ideas: [
                            dummyIdea(),
                            dummyIdea(old: true),
                            dummyIdea(old: true),
                            dummyIdea(old: true),
                            dummyIdea(),
                            dummyIdea(),
                        ],
                        pinnedHeaderColor: .red, sortBy: .constant(.date))
                }
            }
            .coordinateSpace(name: "idea-list-container")
        }
        
        // 2nd preview with loading state
        // ------------------------------
        NavigationStack {
            ZStack { MyBackground()
                ScrollView {
                    IdeaList(ideas: nil, pinnedHeaderColor: .red, sortBy: .constant(.date))
                }
            }
        }
    }
}
