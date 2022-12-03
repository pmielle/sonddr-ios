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
    @EnvironmentObject private var fab: FabService
    @State var selectedTab: Tab? {
        didSet {
            self.fab.selectedTab = self.selectedTab
        }
    }
    let badgeSize: CGFloat = 20
    @State var newDiscussionsNb: Int? = nil
    @State var newNotificationsNb: Int? = nil
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                HomeView()
                    .zIndex(self.selectedTab == .Ideas ? 1 : 0)
                SearchView()
                    .zIndex(self.selectedTab == .Search ? 1 : 0)
                MessagesView(newDiscussionsNb: self.$newDiscussionsNb)
                    .zIndex(self.selectedTab == .Messages ? 1 : 0)
                NotificationsView(newNotificationsNb: self.$newNotificationsNb)
                    .zIndex(self.selectedTab == .Notifications ? 1 : 0)
            }
            self.bottomSafeArea()
            self.bottomBar()
        }.onAppear {
            self.selectedTab = .Ideas
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
                badge: self.newDiscussionsNb
            )
            Spacer()
            self.bottomBarIcon(
                idleSystemName: "bell",
                selectedSystemName: "bell.fill",
                tab: .Notifications,
                badge: self.newNotificationsNb
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
        badge: Int? = nil
    ) -> some View {
        let isSelected = self.selectedTab == tab
        return ZStack(alignment: .topTrailing) {
            Button(action: {
                    self.onBottomBarIconTap(tab: tab)
            }) {
                Image(systemName: isSelected ? selectedSystemName :  idleSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                .padding(10)
            }
            if badge != nil {
                let label = badge! > 99 ? "99+" : "\(badge!)"
                self.BottomBarBadge(label: label)
                    .opacity(tab == self.selectedTab ? 0 : 1)
                    .animation(.easeOut(duration: myShortDurationInSec), value: selectedTab)
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
    }
    
    
    // methods
    // ------------------------------------------
    func onBottomBarIconTap(tab: Tab) {
        if tab != self.selectedTab {
            self.selectedTab = tab
        } else {
            switch tab {
            case .Ideas:
                NotificationCenter.default.post(Notification(name: .ideasBottomBarIconTap))
            default:
                print("bottomBarIconTap not implemented for \(tab)")
            }
        }
    }
}

struct MyTabView_Previews: PreviewProvider {    
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        let fab = FabService()
        
        MyTabView()
            .environmentObject(db)
            .environmentObject(auth)
            .environmentObject(fab)
    }
}
