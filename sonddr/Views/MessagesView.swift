//
//  MessagesView.swift
//  sonddr
//
//  Created by Paul Mielle on 16/11/2022.
//

import SwiftUI

struct MessagesView: View {
    
    // attributes
    // ------------------------------------------
    @Binding var newDiscussionsNb: Int?
    var forceLoadingState: Bool = false
    @EnvironmentObject private var db: DatabaseService
    @EnvironmentObject private var auth: AuthenticationService
    @State private var discussions: [Discussion]? = nil {
        didSet {
            self.newDiscussionsNb = self.discussions != nil ? self.discussions!.count : nil
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
                            self.discussionItem(discussion: dummyDiscussion())
                                .redacted(reason: .placeholder)
                            self.discussionItem(discussion: dummyDiscussion())
                                .redacted(reason: .placeholder)
                            
                        } else {
                            ForEach(self.discussions!) { discussion in
                                self.discussionItem(discussion: discussion)
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
    func discussionItem(discussion: Discussion) -> some View {
        return Text("\(discussion.id)")
    }
    
    
    // methods
    // ------------------------------------------
    func initialLoad() {
        self.discussions = self.getDiscussions()
        if !self.forceLoadingState {
            self.isLoading = false
        }
    }
    
    func getDiscussions() -> [Discussion] {
        return self.db.getDiscussions(user: self.auth.loggedInUser!)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NavigationView {
            MessagesView(newDiscussionsNb: .constant(nil))
                .environmentObject(auth)
                .environmentObject(db)
        }
        
        // 2nd preview with loading state
        // ------------------------------
        NavigationView {
            MessagesView(newDiscussionsNb: .constant(nil), forceLoadingState: true)
                .environmentObject(auth)
                .environmentObject(db)
        }
    }
}
