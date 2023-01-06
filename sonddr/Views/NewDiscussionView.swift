//
//  NewDiscussionView.swift
//  sonddr
//
//  Created by Paul Mielle on 29/12/2022.
//

import SwiftUI

struct NewDiscussionView: View {

    // attributes
    // ------------------------------------------
    // parameters
    @Binding var isPresented: Bool
    var preselectedUser: User? = nil
    let addCallback: (Discussion) -> Void
    // environment
    @EnvironmentObject var auth: AuthenticationService
    @EnvironmentObject var db: DatabaseService
    // constants
    enum FocusedField: Hashable {
        case to
        case body
    }
    // state
    @State var toInputText = ""
    @State var bodyInputText = ""
    @State var recipients: [User] = []
    @State var completionList: [User] = []
    @FocusState var focusedField: FocusedField?
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            GeometryReader {reader in
                ZStack(alignment: .bottomTrailing) { MyBackground()
                    
                    VStack {
                        // To:
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(recipients) { recipient in
                                    Label(recipient.name, systemImage: "xmark")
                                        .myLabel(color: .white)
                                        .foregroundColor(myBackgroundColor)
                                        .onTapGesture {
                                            self.onRecipientTap(user: recipient)
                                        }
                                }
                                TextField(self.recipients.isEmpty ? "To:" : "", text: self.$toInputText)
                                    .myGutter()
                                    .padding(.vertical, mySpacing)
                                    .padding(.leading, self.recipients.isEmpty ? mySpacing : 0)
                                    .onChange(of: self.toInputText) { _ in
                                        self.onToInputTextChange()
                                    }
                            }
                            .myGutter()
                            Divider()
                        }
                        
                        // content
                        ScrollView {
                            VStack {
                                
                                ForEach(self.completionList) { user in
                                    Button {
                                        self.onCompletionItemTap(user: user)
                                    } label: {
                                        self.completionItem(user: user)
                                    }
                                }
                                
                            }
                        }
                        
                        // message input
                        VStack(spacing: 0) {
                            Divider()
                            HStack(spacing: mySpacing) {
                                Button {
                                    print("attach...")
                                } label: {
                                    Image(systemName: "paperclip")
                                }
                                TextField("Your message", text: self.$bodyInputText)
                                    .focused($focusedField, equals: .body)
                                    .onAppear {
                                        if self.preselectedUser != nil {
                                            focusedField = .body
                                        }
                                    }
                            }
                            .frame(height: fabSize)
                            .myGutter()
                            .padding(.vertical, mySpacing)
                            .padding(.trailing, mySpacing + fabSize)
                        }
                    }
                    .padding(.bottom, bottomBarApproxHeight)
                    
                    // fab
                    StandaloneFab(icon: "paperplane", color: myBlueColor) {
                        self.onSubmit()
                    }
                    .padding(.bottom, bottomBarApproxHeight + mySpacing)
                    .padding(.trailing, mySpacing)
                
                }
                .toolbar {
                    self.toolbar()
                }
                .navigationTitle("New discussion")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(myBackgroundColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    if self.preselectedUser != nil {
                        self.recipients.append(self.preselectedUser!)
                    }
                }
            }
        }
    }
    
    
    // subviews
    // ------------------------------------------
    func completionItem(user: User) -> some View {
        HStack(spacing: mySpacing) {
            Image(systemName: "arrow.up.right")
                .foregroundColor(myPrimaryColor)
            Text(user.name)
        }
        .padding(.top, 5)
        .myGutter()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "xmark")
                .onTapGesture {
                    self.isPresented = false
                }
        }
    }
    
    
    // methods
    // ------------------------------------------
    func onRecipientTap(user: User) {
        self.recipients.removeAll { $0 == user }
    }
    
    func onCompletionItemTap(user: User) {
        self.recipients.append(user)
        self.completionList = []
        self.toInputText = ""
    }
    
    func onToInputTextChange() {
        Task {
            self.completionList = try await self.db.getUsers(startsWith: self.toInputText)
        }
    }
    
    func onSubmit() {
        // validate the inputs
        let body = self.bodyInputText
        if (body.isEmpty) {
            print("[error] please enter a message")
            return
        }
        let recipients = self.recipients
        if recipients.isEmpty {
            print("[error] please choose at least one recipient")
            return
        }
        let from = self.auth.loggedInUser!
        let date = Date.now
        // create the new discussion
        let discussion = Discussion(id: randomId(), with: recipients, picture: "DefaultProfilePicture", messages: [MyMessage(id: randomId(), from: from, body: body, date: date)])
        // post it to the parent view
        self.addCallback(discussion)
        // dismiss
        self.isPresented = false
    }
}

struct NewDiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseService(testMode: true)
        let auth = AuthenticationService(db: db, testMode: true)
        
        NewDiscussionView(isPresented: .constant(true)) { discussion in
            print("add discussion \(discussion)")
        }
        .environmentObject(db)
        .environmentObject(auth)
    }
}
