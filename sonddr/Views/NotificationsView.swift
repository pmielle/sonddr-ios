//
//  NotificationsView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct NotificationsView: View {

    // attributes
    // ------------------------------------------
    @Binding var newNotificationsNb: Int?
    var forceLoadingState: Bool = false
    @EnvironmentObject private var db: DatabaseService
    @EnvironmentObject private var auth: AuthenticationService
    @State private var notifications: [MyNotification]? = nil {
        didSet {
            self.newNotificationsNb = self.notifications != nil ? self.notifications!.count : nil
        }
    }
    @State private var isLoading = true
    
    
    // constructor
    // ------------------------------------------
    // ...
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationView {
            ZStack() { MyBackground()
                
                ScrollView {
                    VStack {
                        if self.isLoading {
                            self.notificationItem(notification: dummyNotification())
                                .redacted(reason: .placeholder)
                            self.notificationItem(notification: dummyNotification())
                                .redacted(reason: .placeholder)
                            
                        } else {
                            ForEach(self.notifications!) { notification in
                                self.notificationItem(notification: notification)
                            }
                        }
                    }
                }
                
            }
        }
        .onAppear {
            self.initialLoad()
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func notificationItem(notification: MyNotification) -> some View {
        return Text("\(notification.content)")
    }
    
    
    // methods
    // ------------------------------------------
    func initialLoad() {
        Task {
            await self.getNotifications()
            if !self.forceLoadingState {
                self.isLoading = false
            }
        }
    }
    
    func getNotifications() async {
        do {
            self.notifications = try await self.db.getNotifications(user: self.auth.loggedInUser!)
        } catch {
            print("an error occured: \(error)")
        }
        
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NavigationView {
            NotificationsView(newNotificationsNb: .constant(nil))
                .environmentObject(auth)
                .environmentObject(db)
        }
        
        // 2nd preview with loading state
        // ------------------------------
        NavigationView {
            NotificationsView(newNotificationsNb: .constant(nil), forceLoadingState: true)
                .environmentObject(auth)
                .environmentObject(db)
        }
    }
}
