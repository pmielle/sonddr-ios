//
//  MyTabView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

enum Tab {
    case Ideas
    case Search
    case Messages
    case Notifications
}

struct MyTabView: View {

    // attributes
    // ------------------------------------------
    @State var selectedTab: Tab = .Ideas
    let badgeSize: CGFloat = 20
    
    
    // constructor
    // ------------------------------------------
    init() {
        self.changeNavbarStyle()
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                // ideas
                NavigationView {
                    HomeView()
                }
                .zIndex(self.selectedTab == .Ideas ? 1 : 0)
                // search
                SearchView()
                    .zIndex(self.selectedTab == .Search ? 1 : 0)
                // messages
                MessagesView()
                    .zIndex(self.selectedTab == .Messages ? 1 : 0)
                // notifications
                NotificationsView()
                    .zIndex(self.selectedTab == .Notifications ? 1 : 0)
            }
            self.bottomSafeArea()
            self.bottomBar()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func bottomSafeArea() -> some View {
        myBackgroundColor
            .frame(height: 1)
            .background(myBackgroundColor.ignoresSafeArea(edges: .bottom))
    }
    
    func bottomBar() -> some View {
        HStack {
            Spacer()
            self.bottomBarIcon(
                idleSystemName: "lightbulb",
                selectedSystemName: "lightbulb.fill",
                tab: .Ideas
            )
            Spacer()
            self.bottomBarIcon(
                idleSystemName: "magnifyingglass",
                selectedSystemName: "magnifyingglass",
                tab: .Search
            )
            Spacer()
            self.bottomBarIcon(
                idleSystemName: "bubble.left",
                selectedSystemName: "bubble.left.fill",
                tab: .Messages,
                badge: "1"
            )
            Spacer()
            self.bottomBarIcon(
                idleSystemName: "bell",
                selectedSystemName: "bell.fill",
                tab: .Notifications,
                badge: "99+"
            )
            Spacer()
        }
        .padding(.vertical, 5)
        .background(myBackgroundColor)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    func bottomBarIcon(
        idleSystemName: String,
        selectedSystemName: String,
        tab: Tab,
        badge: String = ""
    ) -> some View {
        let isSelected = self.selectedTab == tab
        return ZStack(alignment: .topTrailing) {
            Button(action: {
                    self.selectedTab = tab
            }) {
                Image(systemName: isSelected ? selectedSystemName :  idleSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                .padding(10)
            }
            .buttonStyle(.plain)
            if badge != "" {
                self.BottomBarBadge(label: badge)
            }
            if (tab == .Ideas && isSelected) {
                self.sparkles()
            }
        }
    }
    
    func sparkles() -> some View {
        VStack {
            Image(systemName: "sparkle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(.yellow)
                .offset(x: -1, y: 4)
            Image(systemName: "sparkle")
                .resizable()
                .scaledToFit()
                .frame(width: 7)
                .foregroundColor(.yellow)
                .offset(x: 4, y: -2)

        }
    }
    
    func BottomBarBadge(label: String) -> some View {
        Text("\(label)")
            .font(.system(size: 14))
            .padding(.horizontal, 4)
            .frame(minWidth: badgeSize, minHeight: badgeSize, maxHeight: badgeSize)
            .background(.red)
            .cornerRadius(badgeSize / 2)
            .offset(x: badgeSize / 3)
    }
    
    
    // methods
    // ------------------------------------------
    func changeNavbarStyle() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(myBackgroundColor)
        coloredNavAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
    }
}
